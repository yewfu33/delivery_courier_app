import 'dart:convert';
import 'dart:io';

import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/model/document.dart';
import 'package:delivery_courier_app/model/registrationModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/pages/resetPasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../constant.dart';
import 'appProvider.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

class LoginModel {
  String email;
  String password;

  Map toMap() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class UserProvider extends ChangeNotifier {
  Status _status = Status.uninitialized;
  Status get status => _status;

  final picker = ImagePicker();
  File _pimage;
  File get pImage => _pimage;

  LoginModel loginModel = LoginModel();

  RegistrationModel registrationModel = RegistrationModel();

  UserProvider.initialize() {
    validateAuthState();
  }

  Future loginSubmit(BuildContext context) async {
    // post the login form
    try {
      final http.Response result = await http.post(
        '${Constant.serverName}${Constant.accountPath}/login',
        body: json.encode(loginModel.toMap()),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (result.statusCode == 200) {
        final User user =
            User.fromJson(json.decode(result.body) as Map<String, dynamic>);
        // chec whether is onBoard
        if (!user.onBoard) {
          // set user in prefs
          await setUserPrefs(user);
          // reflect the auth state
          validateAuthState();

          // back to landing page
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        } else {
          // change to reset password screen if user is on board
          changeScreen(
            context,
            ResetPasswordPage(
              title: "Please change your password after the first login.",
              user: user,
            ),
          );
        }
      } else {
        final body = json.decode(result?.body);

        if (body["message"] != null) {
          AppProvider.openCustomDialog(
              context, "Error", body["message"] as String,
              isPop: true);
        } else {
          AppProvider.showRetryDialog(context, message: result.reasonPhrase);
        }
      }
    } catch (e) {
      // show retry dialog
      AppProvider.showRetryDialog(context);
    }
  }

  Future registrationSubmit(BuildContext context) async {
    try {
      final http.Response result = await http.post(
        '${Constant.serverName}${Constant.accountPath}/register',
        body: json.encode(registrationModel.toMap()),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (result.statusCode == 200) {
        AppProvider.openCustomDialog(
          context,
          "Registration sent",
          "You will receive email confirmation after your registration been approved",
          isPop: false,
        );
      } else {
        final body = json.decode(result?.body);

        if (body["message"] != null) {
          AppProvider.openCustomDialog(
              context, "Error", body["message"] as String,
              isPop: true);
        } else {
          AppProvider.showRetryDialog(context, message: result.reasonPhrase);
        }
      }
    } catch (e) {
      // show retry dialog
      AppProvider.showRetryDialog(context);
    }
  }

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      _pimage = File(pickedFile.path);
      // read base64 image
      registrationModel.profilePicture =
          base64Encode(_pimage.readAsBytesSync());
      // read image name
      registrationModel.profilePictureName = pickedFile.path.split('/').last;
    }

    notifyListeners();
  }

  void showPickImageModal(BuildContext context) {
    // show modal selection
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Wrap(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Align(
                  child: Text(
                    "Choose Option",
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 15.5),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('From Gallery'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('From Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  Future getDocument(ImageSource source, String docName) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      final Document d = Document();
      d.name = docName;
      // read base64 image
      final bytes = await pickedFile.readAsBytes();
      d.document = base64Encode(bytes);

      // read image name
      d.documentName = pickedFile.path.split('/').last;

      if (registrationModel.documents.isEmpty) {
        registrationModel.documents.add(d);
      } else {
        final i =
            registrationModel.documents.indexWhere((e) => e.name == docName);
        if (i >= 0) {
          registrationModel.documents.removeAt(i);
          registrationModel.documents.add(d);
        } else {
          registrationModel.documents.add(d);
        }
      }
    }

    notifyListeners();
  }

  bool validateDocuments() {
    return registrationModel.documents.length >= 2;
  }

  Future setUserPrefs(User u) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("uid", u.id);
    prefs.setString("name", u.name);
    prefs.setString("phoneNum", u.phoneNum);
    prefs.setString("token", u.token);
    prefs.setString("email", u.email);
    prefs.setString("profile_pic", u.profilePic);
    prefs.setBool("onBoard", u.onBoard);
  }

  Future<User> getUserFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final u = User()
      ..id = prefs.getInt("uid")
      ..name = prefs.getString("name")
      ..phoneNum = prefs.getString("phoneNum")
      ..token = prefs.getString("token")
      ..email = prefs.getString("email")
      ..profilePic = prefs.getString("profile_pic")
      ..onBoard = prefs.getBool("onBoard");

    return u;
  }

  Stream<User> validateAuthState() async* {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("uid")) {
      _status = Status.authenticated;
      // set prefs value to user variable
      final u = await getUserFromPrefs();
      yield u;
    } else {
      _status = Status.unauthenticated;
      // end the future
      yield null;
    }
  }

  Future signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // clear prefs
    await prefs.clear();

    _status = Status.unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}

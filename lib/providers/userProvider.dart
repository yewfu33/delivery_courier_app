import 'dart:convert';

import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/pages/resetPasswordPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

import '../constant.dart';
import 'appProvider.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

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
  Future<User> initUser;
  User _user;
  Status _status = Status.Uninitialized;

  User get user => _user;
  Status get status => _status;

  LoginModel loginModel = LoginModel();

  UserProvider.initialize() {
    validateAuthState();
  }

  Future loginSubmit(BuildContext context) async {
    // post the login form
    try {
      http.Response result = await http.post(
        Constant.serverName + Constant.accountPath + '/login',
        body: json.encode(loginModel.toMap()),
        headers: {
          'Content-type': 'application/json',
        },
      );

      if (result.statusCode == 200) {
        print(result.body);

        _user = User.fromJson(json.decode(result.body));
        // chec whether is onBoard
        if (!user.onBoard) {
          // set user in prefs
          await setUserPrefs(_user);
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
              user: _user,
            ),
          );
        }
      } else {
        var body = json.decode(result.body);

        if (body["message"] != null) {
          AppProvider.openCustomDialog(context, "Error", body["message"], true);
        } else {
          AppProvider.showRetryDialog(context);
        }
      }
    } catch (e) {
      print(e);
      // show retry dialog
      AppProvider.showRetryDialog(context);
    }
  }

  Future setUserPrefs(User u) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("uid", u.id);
    prefs.setString("name", u.name);
    prefs.setString("phoneNum", u.phoneNum);
    prefs.setString("token", u.token);
    prefs.setString("email", u.email);
    prefs.setString("profile_pic", u.profilePic);
    prefs.setBool("onBoard", u.onBoard);
  }

  Future<User> setUserFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    User setUser = User();

    setUser.id = prefs.getInt("uid");
    setUser.name = prefs.getString("name");
    setUser.phoneNum = prefs.getString("phoneNum");
    setUser.token = prefs.getString("token");
    setUser.email = prefs.getString("email");
    setUser.profilePic = prefs.getString("profile_pic");
    setUser.onBoard = prefs.getBool("onBoard");

    // assign private field user
    _user = setUser;

    return _user;
  }

  Stream<User> validateAuthState() async* {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("uid")) {
      _status = Status.Authenticated;
      // set prefs value to user variable
      if (_user == null) {
        var u = await setUserFromPrefs();
        yield u;
      } else {
        yield _user;
      }
    } else {
      _status = Status.Unauthenticated;
      // end the future
      yield null;
    }
  }

//   void validateAuthState() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     if (prefs.containsKey("uid")) {
//       _status = Status.Authenticated;
//       // set prefs value to user variable
//       if (_user == null) {
//         await setUserFromPrefs();
//       } else {
//         initUser = Future.delayed(Duration.zero, () => _user);
//       }
//     } else {
//       _status = Status.Unauthenticated;
//       // end the future
//       initUser = Future.delayed(Duration.zero, () => null);
//     }
//   }

  Future<String> readProfilePic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString("profile_pic");
  }

  Future signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // clear prefs
    prefs.clear();
    _user = null;

    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }
}

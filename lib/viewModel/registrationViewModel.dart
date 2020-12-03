import 'dart:convert';
import 'dart:io';

import 'package:delivery_courier_app/model/document.dart';
import 'package:delivery_courier_app/model/enum.dart';
import 'package:delivery_courier_app/model/registrationModel.dart';
import 'package:delivery_courier_app/providers/appProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';

class RegistrationViewModel with ChangeNotifier {
  bool autoValidateForm = false;

  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;

  final picker = ImagePicker();
  File _pimage;
  get pImage => _pimage;

  bool isPosting = false;

  RegistrationModel registrationModel = RegistrationModel();

  final List vehicleTypeItem = <DropdownMenuItem<int>>[
    DropdownMenuItem(
      child: Text(VehicleType.Bike.name),
      value: VehicleType.Bike.index,
    ),
    DropdownMenuItem(
      child: Text(VehicleType.Car.name),
      value: VehicleType.Car.index,
    ),
    DropdownMenuItem(
      child: Text(VehicleType.Lorry.name),
      value: VehicleType.Lorry.index,
    ),
  ];

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      _pimage = File(pickedFile.path);
      // read base64 image
      registrationModel.profilePicture =
          base64Encode(_pimage.readAsBytesSync());
      // read image name
      registrationModel.profilePictureName = pickedFile.path.split('/').last;
      print(registrationModel.profilePicture);
    } else {
      print('No image selected.');
    }

    notifyListeners();
  }

  void showPickImageModal(context) {
    // show modal selection
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: Wrap(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Choose Option",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 15.5),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('From Gallery'),
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('From Camera'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }

  void getDocument(ImageSource source, String docName) async {
    final pickedFile = await picker.getImage(source: source);

    if (pickedFile != null) {
      Document d = new Document();
      d.name = docName;
      // read base64 image
      var bytes = await pickedFile.readAsBytes();
      d.document = base64Encode(bytes);

      // read image name
      d.documentName = pickedFile.path.split('/').last;

      if (registrationModel.documents.length == 0) {
        registrationModel.documents.add(d);
      } else {
        var i =
            registrationModel.documents.indexWhere((e) => e.name == docName);
        if (i >= 0) {
          registrationModel.documents.removeAt(i);
          registrationModel.documents.add(d);
        } else {
          registrationModel.documents.add(d);
        }
      }
    } else {
      print('No image selected.');
    }

    notifyListeners();
  }

  bool validateDocuments() {
    return registrationModel.documents.length >= 2;
  }

  bool validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      autoValidateForm = true;
      notifyListeners();
      return false;
    }
  }

  void postForm(Map body, BuildContext context) async {
    // bring down the keyboard
    FocusScope.of(context).unfocus();
    print(body.toString());
    // set posting loading true
    isPosting = true;
    notifyListeners();

    try {
      http.Response result = await http.post(
        Constant.serverName + Constant.accountPath + '/register',
        body: json.encode(body),
        headers: {
          'Content-type': 'application/json',
        },
      );

      print(result.statusCode);
      if (result.statusCode == 200) {
        AppProvider.openCustomDialog(
            context,
            "Registration sent",
            "You will receive email confirmation after your registration been approved",
            false);
      } else {
        var body = json.decode(result?.body);

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
    } finally {
      isPosting = false;
      notifyListeners();
    }
  }
}

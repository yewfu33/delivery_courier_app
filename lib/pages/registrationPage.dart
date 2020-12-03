import 'package:delivery_courier_app/constant.dart';
import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/helpers/util.dart';
import 'package:delivery_courier_app/viewModel/registrationViewModel.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatelessWidget {
  final _phoneFieldController = TextEditingController(text: '+60 ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: ChangeNotifierProvider(
          create: (_) => RegistrationViewModel(),
          builder: (context, _) {
            final model = context.watch<RegistrationViewModel>();

            return SingleChildScrollView(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        model.showPickImageModal(context);
                      },
                      child: CircleAvatar(
                        radius: 40,
                        // backgroundColor: Color(Constant.primaryColor),
                        backgroundImage: model.pImage == null
                            ? AssetImage('assets/img/avatar.jpg')
                            : FileImage(model.pImage),
                        // child: Icon(Icons.camera_alt),
                      ),
                    ),
                    Form(
                      key: model.formKey,
                      autovalidate: model.autoValidateForm,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'This field is required.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                model.registrationModel.name = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Name',
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'This field is required.';
                                }
                                if (value == '+60 ') {
                                  return 'This field is required.';
                                }
                                return null;
                              },
                              controller: _phoneFieldController,
                              onSaved: (value) {
                                model.registrationModel.phoneNum =
                                    value.substring(4);
                              },
                              inputFormatters: [
                                CustomPhoneNumberFormatter(),
                              ],
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'This field is required.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                model.registrationModel.email = value;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: DropdownButtonFormField(
                              items: model.vehicleTypeItem,
                              validator: (value) => value == null
                                  ? 'This field is required'
                                  : null,
                              decoration: InputDecoration(
                                labelText: 'Owned Vehicle Type',
                                contentPadding: EdgeInsets.zero,
                              ),
                              onChanged: (value) {
                                model.registrationModel.vehicleType = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.trim().isEmpty) {
                                  return 'This field is required.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                model.registrationModel.vehiclePlateNo = value;
                              },
                              decoration: InputDecoration(
                                labelText: 'Vehicle Plate No',
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () {
                            if (model.validateForm()) {
                              // save current context and move to upload document page
                              //   print(registrationModel.toMap());
                              changeScreen(
                                  context,
                                  ChangeNotifierProvider.value(
                                    value: model,
                                    child: UploadDocumentPage(),
                                  ));
                            }
                          },
                          color: Constant.primaryColor,
                          child: Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 0.4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class UploadDocumentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Your Document'),
      ),
      body: Consumer<RegistrationViewModel>(
        builder: (_, model, __) => SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Please upload your documents as below',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
                DocumentSection(
                  title: 'Identity Card*',
                  photoCallback: () {
                    model.getDocument(ImageSource.gallery, "Identity Card");
                  },
                  cameraCallback: () {
                    model.getDocument(ImageSource.camera, "Identity Card");
                  },
                  checked: model.registrationModel.documents
                          .indexWhere((e) => e.name == "Identity Card") >=
                      0,
                ),
                DocumentSection(
                  title: 'Driving License*',
                  photoCallback: () {
                    model.getDocument(ImageSource.gallery, "Driving License");
                  },
                  cameraCallback: () {
                    model.getDocument(ImageSource.camera, "Driving License");
                  },
                  checked: model.registrationModel.documents
                          .indexWhere((e) => e.name == "Driving License") >=
                      0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0),
                  child: (model.isPosting)
                      ? Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Constant.primaryColor)),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () {
                              if (model.validateDocuments()) {
                                model.postForm(
                                    model.registrationModel.toMap(), context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) {
                                    return new AlertDialog(
                                      content: Text(
                                          "Please upload the required documents"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('OK'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            color: Constant.primaryColor,
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.4,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DocumentSection extends StatelessWidget {
  final String title;
  final VoidCallback photoCallback;
  final VoidCallback cameraCallback;
  final bool checked;

  const DocumentSection(
      {Key key,
      @required this.title,
      @required this.photoCallback,
      @required this.cameraCallback,
      @required this.checked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.add_photo_alternate),
              iconSize: 30,
              onPressed: photoCallback,
            ),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: Icon(Icons.add_a_photo),
              iconSize: 30,
              onPressed: cameraCallback,
            ),
          ),
          Expanded(
              flex: 1,
              child: !checked
                  ? Icon(Icons.check_box_outline_blank, size: 30)
                  : Icon(
                      Icons.check_box,
                      size: 30,
                      color: Colors.green,
                    )),
        ],
      ),
    );
  }
}

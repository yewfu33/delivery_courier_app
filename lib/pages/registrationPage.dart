import 'package:delivery_courier_app/constant.dart';
import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/helpers/util.dart';
import 'package:delivery_courier_app/model/enum.dart';
import 'package:delivery_courier_app/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _phoneFieldController;

  bool _autoValidateForm = false;

  final _formKey = GlobalKey<FormState>();

  final List<DropdownMenuItem<int>> vehicleTypeItem = <DropdownMenuItem<int>>[
    DropdownMenuItem(
      value: VehicleType.bike.index,
      child: Text(VehicleType.bike.name),
    ),
    DropdownMenuItem(
      value: VehicleType.car.index,
      child: Text(VehicleType.car.name),
    ),
  ];

  bool validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      setState(() {
        _autoValidateForm = true;
      });
      return false;
    }
  }

  @override
  void initState() {
    _phoneFieldController = TextEditingController(text: '+60 ');
    super.initState();
  }

  @override
  void dispose() {
    _phoneFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  model.showPickImageModal(context);
                },
                child: CircleAvatar(
                  radius: 40,
                  // backgroundColor: Color(Constant.primaryColor),
                  backgroundImage: (model.pImage == null)
                      ? const AssetImage('assets/img/avatar.jpg')
                      : FileImage(model.pImage) as ImageProvider,
                  // child: Icon(Icons.camera_alt),
                ),
              ),
              Form(
                key: _formKey,
                autovalidate: _autoValidateForm,
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
                        decoration: const InputDecoration(
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
                          model.registrationModel.phoneNum = value.substring(4);
                        },
                        inputFormatters: [
                          CustomPhoneNumberFormatter(),
                        ],
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
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
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: DropdownButtonFormField(
                        items: vehicleTypeItem,
                        validator: (value) =>
                            value == null ? 'This field is required' : null,
                        decoration: const InputDecoration(
                          labelText: 'Owned Vehicle Type',
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: (int value) {
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
                        decoration: const InputDecoration(
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
                      // bring down the keyboard
                      FocusScope.of(context).unfocus();

                      if (validateForm()) {
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
                    child: const Text(
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
      ),
    );
  }
}

class UploadDocumentPage extends StatefulWidget {
  @override
  _UploadDocumentPageState createState() => _UploadDocumentPageState();
}

class _UploadDocumentPageState extends State<UploadDocumentPage> {
  bool _isPosting = false;

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Your Document'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const Text(
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
                child: _isPosting
                    ? const Center(
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Constant.primaryColor)),
                      )
                    : SizedBox(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: () async {
                            if (model.validateDocuments()) {
                              setState(() {
                                _isPosting = true;
                              });
                              await model.registrationSubmit(context);
                              setState(() {
                                _isPosting = false;
                              });
                            } else {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    content: const Text(
                                        "Please upload the required documents"),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      )
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          color: Constant.primaryColor,
                          child: const Text(
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
        children: [
          Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.add_photo_alternate),
              iconSize: 30,
              onPressed: photoCallback,
            ),
          ),
          Expanded(
            child: IconButton(
              icon: const Icon(Icons.add_a_photo),
              iconSize: 30,
              onPressed: cameraCallback,
            ),
          ),
          Expanded(
            child: !checked
                ? const Icon(Icons.check_box_outline_blank, size: 30)
                : const Icon(
                    Icons.check_box,
                    size: 30,
                    color: Colors.green,
                  ),
          ),
        ],
      ),
    );
  }
}

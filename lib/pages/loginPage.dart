import 'package:delivery_courier_app/providers/userProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool autoValidateForm = false;
  bool isPosting = false;

  bool validateForm() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      return true;
    } else {
      setState(() {
        autoValidateForm = true;
      });
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider model =
        Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
            key: _formKey,
            autovalidate: autoValidateForm,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      model.loginModel.email = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      model.loginModel.password = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FlatButton(
                      onPressed: () {},
                      textColor: Constant.primaryColor,
                      child: const Text('RESET PASSWORD'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: isPosting
                      ? const Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Constant.primaryColor)),
                        )
                      : SizedBox(
                          width: double.infinity,
                          child: RaisedButton(
                            onPressed: () async {
                              // bring down the keyboard
                              FocusScope.of(context).unfocus();

                              if (validateForm()) {
                                // set posting loading true
                                setState(() {
                                  isPosting = true;
                                });

                                await model.loginSubmit(context);

                                setState(() {
                                  isPosting = false;
                                });
                              }
                            },
                            color: Constant.primaryColor,
                            child: const Text(
                              'Log-in',
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0.4,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

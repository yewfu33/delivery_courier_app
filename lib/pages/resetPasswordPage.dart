import 'dart:convert';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/providers/appProvider.dart';
import 'package:delivery_courier_app/providers/userProvider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class ResetPasswordPage extends StatefulWidget {
  final String title;
  final User user;

  const ResetPasswordPage({
    Key key,
    this.title = "",
    @required this.user,
  }) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  final String changePasswordPath = '/change_password';
  bool _autoValidateForm = false;
  bool isPosting = false;

  String oldPassword;
  String newPassword;
  String confirmPassword;

  bool _validateForm() {
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

  Future<bool> onSubmit(BuildContext context) async {
    // post the login form
    try {
      final body = {
        'id': widget.user.id,
        'oldPassword': oldPassword,
        'password': newPassword,
      };

      final jwtHeader = {
        'Content-type': 'application/json',
        'Authorization': 'Bearer ${widget.user.token}'
      };

      http.Response result = await http.post(
        Constant.serverName + Constant.accountPath + changePasswordPath,
        body: json.encode(body),
        headers: jwtHeader,
      );

      if (result.statusCode == 200) {
        return true;
      } else {
        Map<String, dynamic> body = json.decode(result.body);

        if (body["message"] != null) {
          AppProvider.openCustomDialog(context, "Error", body["message"], true);
        }

        return false;
      }
    } catch (e) {
      print(e);
      // show retry dialog
      AppProvider.showRetryDialog(context);
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _pass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider model = context.watch<UserProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
            key: _formKey,
            autovalidate: _autoValidateForm,
            child: Column(
              children: [
                (widget.title.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                (widget.title.isEmpty)
                    ? Padding(
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
                            oldPassword = value;
                          },
                          decoration: const InputDecoration(
                            hintText: 'Old Password',
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: TextFormField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    controller: _pass,
                    validator: (value) {
                      if (value.trim().isEmpty) {
                        return 'This field is required.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      newPassword = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'New Password',
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
                      if (value != _pass.text) {
                        return 'Password does not match.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      confirmPassword = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: (isPosting)
                      ? Center(
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

                              if (_validateForm()) {
                                print('valid form');
                                // set posting loading true
                                setState(() => isPosting = true);

                                // send the form
                                var success = await onSubmit(context);

                                if (success) {
                                  // set user in prefs
                                  await model.setUserPrefs(widget.user);
                                  // reflect the auth state
                                  model.validateAuthState();
                                  // back to landing page
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/', (route) => false);
                                }

                                setState(() => isPosting = false);
                              } else {
                                print('invalid form');
                              }
                            },
                            color: Constant.primaryColor,
                            child: Text(
                              (widget.title.isNotEmpty)
                                  ? 'Continue'
                                  : 'Reset Password',
                              style: const TextStyle(
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

import 'package:flutter/material.dart';

import '../constant.dart';

class ResetPasswordPage extends StatefulWidget {
  final String title;

  const ResetPasswordPage({
    Key key,
    this.title = "",
  }) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pass = TextEditingController();
  bool _autoValidateForm = false;

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

  @override
  void dispose() {
    super.dispose();
    _pass.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          style: TextStyle(
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
                  child: SizedBox(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () {
                        _validateForm();
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

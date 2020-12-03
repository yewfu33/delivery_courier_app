import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/pages/loginPage.dart';
import 'package:delivery_courier_app/pages/registrationPage.dart';
import 'package:delivery_courier_app/widgets/Slider.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 25),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: SliderView(slide: slideItems),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: FlatButton(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  onPressed: () {
                    changeScreen(
                      context,
                      RegistrationPage(),
                    );
                  },
                  child: Text(
                    'Registration Now',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 0.4,
                    ),
                  ),
                  color: Constant.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey[300])),
                child: RaisedButton(
                  elevation: 1.5,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  onPressed: () {
                    changeScreen(context, LoginPage());
                  },
                  child: Text(
                    'Account Log In',
                    style: const TextStyle(
                      fontSize: 16,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../constant.dart';

// splash screen
class SplashScreen extends StatelessWidget {
  const SplashScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Constant.primaryColor),
        ),
      ),
    );
  }
}

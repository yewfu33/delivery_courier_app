import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Loading.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.local_shipping, size: 35),
            Loading(),
          ],
        ));
  }
}

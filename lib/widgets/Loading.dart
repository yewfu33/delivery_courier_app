import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../constant.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SpinKitFadingCircle(
      color: Constant.primaryColor,
      size: 30,
    ));
  }
}

import 'package:flutter/material.dart';

void changeScreen(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

// request here
void changeScreenReplacement(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}

void popScreen(BuildContext context) => Navigator.pop(context);

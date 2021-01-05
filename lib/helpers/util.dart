import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// get vehicle type
String setVehicleType(int type) {
  switch (type) {
    case 0:
      return 'Motorbike';
      break;
    case 1:
      return 'Car';
      break;
    default:
      return 'Motorbike';
  }
}

class MyScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}

class CustomPhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    const String newText = '+60 ';

    if (newValue.selection.baseOffset < 4) {
      return newValue.copyWith(
        text: newText,
        selection: const TextSelection.collapsed(offset: newText.length),
      );
    }

    if (oldValue.text.startsWith('+60 ')) {
      return newValue;
    }

    return newValue;
  }
}

import 'package:flutter/material.dart';

class GreyBoxContainer extends StatelessWidget {
  final Widget child;

  const GreyBoxContainer({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: child,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.all(Radius.circular(3)),
      ),
    );
  }
}

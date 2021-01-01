import 'package:flutter/material.dart';

import 'GreyBoxContainer.dart';

class SignaturesSection extends StatelessWidget {
  const SignaturesSection({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          GreyBoxContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Signatures',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                Icon(Icons.add, size: 24),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text('No Signature yet'),
            ],
          ),
        ],
      ),
    );
  }
}

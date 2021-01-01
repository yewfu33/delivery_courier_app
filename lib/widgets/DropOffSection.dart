import 'package:delivery_courier_app/model/dropPointModel.dart';
import 'package:delivery_courier_app/providers/mapProvider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class DropOffLocationSection extends StatefulWidget {
  final List<DropPointModel> dp;

  const DropOffLocationSection({Key key, this.dp}) : super(key: key);

  @override
  _DropOffLocationSectionState createState() => _DropOffLocationSectionState();
}

class _DropOffLocationSectionState extends State<DropOffLocationSection> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final MapProvider model = Provider.of<MapProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              'Drop Off Location (${widget.dp.length})',
              style: TextStyle(
                color: Constant.primaryColor,
                letterSpacing: 0.4,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Stepper(
            physics: NeverScrollableScrollPhysics(),
            controlsBuilder: (_,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                Container(),
            currentStep: _step,
            onStepTapped: (int i) {
              setState(() => _step = i);
              model.onTapDropOffLocation(i);
            },
            steps: [
              for (var i = 0; i < widget.dp.length; i++)
                Step(
                  isActive: true,
                  title: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.76,
                    child: Text(
                      widget.dp[i].address,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: const TextStyle(height: 1.3, letterSpacing: 0.3),
                    ),
                  ),
                  subtitle: Text(DateFormat('dd MMM yyyy h:mm a')
                      .format(widget.dp[i].dateTime)),
                  content: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('+60${widget.dp[i].contact}'),
                        const SizedBox(height: 3),
                        (widget.dp[i].comment.isNotEmpty)
                            ? Text(widget.dp[i].comment)
                            : SizedBox.shrink(),
                      ],
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}

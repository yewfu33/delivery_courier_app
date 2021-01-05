import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/providers/mapProvider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constant.dart';

class PickUpSection extends StatelessWidget {
  final OrderModel order;
  const PickUpSection({Key key, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MapProvider model = Provider.of<MapProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.0),
            child: Text(
              'Pickup Location',
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
            physics: const NeverScrollableScrollPhysics(),
            controlsBuilder: (BuildContext context,
                    {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
                Container(),
            onStepTapped: (index) {
              model.onTapPickUpLocation();
            },
            steps: [
              Step(
                isActive: true,
                title: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.76,
                  child: Text(
                    order.address,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(height: 1.3, letterSpacing: 0.3),
                  ),
                ),
                subtitle: Text(
                    "Today at ${DateFormat('h:mm a').format(order.dateTime)}"),
                content: Container(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('+60${order.contact}'),
                      const SizedBox(height: 3),
                      if (order.comment.isNotEmpty)
                        Text(order.comment)
                      else
                        const SizedBox.shrink(),
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(
                          children: const [
                            FaIcon(FontAwesomeIcons.wallet),
                            SizedBox(width: 6),
                            Text('Payment at this address'),
                          ],
                        ),
                      ),
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

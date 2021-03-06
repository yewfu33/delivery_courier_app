import 'package:delivery_courier_app/helpers/util.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/pages/mapView.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

class PickOrderList extends StatelessWidget {
  final OrderModel orderModel;
  final User user;
  final bool isRestoreOnTaskPage;

  const PickOrderList({
    Key key,
    @required this.orderModel,
    @required this.user,
    this.isRestoreOnTaskPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // push to detail page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MapView(user: user, isRestoreOnTaskPage: isRestoreOnTaskPage),
            settings: RouteSettings(arguments: orderModel),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.35),
              blurRadius: 3,
              offset: const Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.access_time),
                const SizedBox(width: 7),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1.5, horizontal: 4),
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    DateFormat('h:mm a').format(orderModel.dateTime),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                const Spacer(),
                Text(
                  '#${orderModel.orderId}',
                  style: const TextStyle(color: Colors.grey, fontSize: 13.5),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 9, bottom: 9),
              child: Text(
                'RM ${orderModel.price}',
                style: const TextStyle(
                  fontSize: 16.5,
                  color: Constant.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Text(
                'Addresses: ${orderModel.dropPoint.length}',
                // DateFormat('dd MMM yyyy | h:mm a').format(order.dateTime),
                style: const TextStyle(fontSize: 14.5),
              ),
            ),
            Row(
              children: <Widget>[
                if (orderModel.vehicleType == 0)
                  const FaIcon(FontAwesomeIcons.motorcycle, size: 18.5),
                if (orderModel.vehicleType == 1)
                  const FaIcon(FontAwesomeIcons.car, size: 18.5),
                const SizedBox(width: 6),
                Text(
                  'By ${setVehicleType(orderModel.vehicleType)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

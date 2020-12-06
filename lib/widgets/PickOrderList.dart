import 'package:delivery_courier_app/helpers/util.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constant.dart';

class PickOrderList extends StatelessWidget {
  final OrderModel orderModel;
  const PickOrderList({Key key, @required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // push to detail page
        Navigator.pushNamed(context, '/details', arguments: orderModel);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 11),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'RM 30',
                    style: TextStyle(
                      fontSize: 18,
                      color: Constant.primaryColor,
                      letterSpacing: 0.4,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Order #${orderModel.orderId}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13.5,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Arrive at 11.42 pm',
                  // DateFormat('dd MMM yyyy | h:mm a').format(order.dateTime),
                  style: TextStyle(
                    fontSize: 14.5,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  'Drop point: ${orderModel.dropPoint.length}',
                  // DateFormat('dd MMM yyyy | h:mm a').format(order.dateTime),
                  style: TextStyle(fontSize: 14.5),
                ),
              ),
              Row(
                children: <Widget>[
                  if (orderModel.vehicleType == 0)
                    FaIcon(
                      FontAwesomeIcons.motorcycle,
                    ),
                  if (orderModel.vehicleType == 1)
                    FaIcon(
                      FontAwesomeIcons.car,
                    ),
                  SizedBox(width: 10),
                  Text(
                    'By ${setVehicleType(orderModel.vehicleType)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, size: 15),
                ],
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 3,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
        ),
      ),
    );
  }
}

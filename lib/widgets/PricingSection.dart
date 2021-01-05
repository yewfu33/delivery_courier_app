import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class PriceSection extends StatelessWidget {
  const PriceSection({
    Key key,
    @required this.order,
  }) : super(key: key);

  final OrderModel order;

  void showPricingDetails(BuildContext context, double fee, double commission,
      {String paymentStatus = "Paid"}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
            primary: Constant.primaryColor,
          ),
        ),
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Order fee"),
                  Text("RM $fee"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Your Commission"),
                  Text("RM $commission"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Payment Method"),
                  Text("Cash"),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Payment Status"),
                  Text(paymentStatus),
                ],
              ),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(_).pop();
              },
              child: const Text('OK'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Total Amount",
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                      fontSize: 13.5)),
              const SizedBox(height: 4),
              Text("RM ${order.price}",
                  style: const TextStyle(
                      color: Constant.primaryColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 20.5)),
            ],
          ),
          FlatButton(
            onPressed: () {
              showPricingDetails(context, order.price, order.price * 0.8,
                  paymentStatus: "Pending");
            },
            textColor: Constant.primaryColor,
            child: const Text("Show details",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

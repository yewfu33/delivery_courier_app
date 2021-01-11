import 'dart:convert';

import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/model/paymentModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/providers/taskProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../constant.dart';
import 'GreyBoxContainer.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({
    Key key,
    @required this.user,
    @required this.order,
  }) : super(key: key);

  final User user;
  final OrderModel order;

  @override
  _PaymentSectionState createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  TaskProvider model;
  String paymentStatus = "Pending";
  double commission;
  bool added = false;
  bool loading = false;
  final getCourierCommissionPath =
      "${Constant.serverName}api/couriers/commission/";
  final addPaymentPath = "${Constant.serverName}api/orders/payment";

  @override
  void initState() {
    super.initState();
    //obtain model instance with listen false
    model = Provider.of<TaskProvider>(context, listen: false);

    readCourierCommission().then((c) {
      setState(() {
        commission = c;
      });
    });
  }

  Future<double> readCourierCommission() async {
    try {
      final res = await http.get(
        getCourierCommissionPath + widget.user.id.toString(),
        headers: {
          "authorization": "Bearer ${widget.user.token}",
        },
      );

      if (res.statusCode == 200) {
        if (double.tryParse(res.body) != null) {
          return double.tryParse(res.body);
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> addPayment(BuildContext context) async {
    try {
      final postBody = PaymentModel(
        amount: widget.order.price,
        courierPay: widget.order.price * commission,
        orderId: widget.order.orderId,
        courierId: widget.user.id,
        userId: widget.order.userId,
      );

      final res = await http.post(
        addPaymentPath,
        headers: {
          "authorization": "Bearer ${widget.user.token}",
          "content-type": "application/json",
        },
        body: json.encode(postBody.toMap()),
      );

      if (res.statusCode == 200) {
        setState(() {
          paymentStatus = "Paid";
        });

        return true;
      } else {
        showRetryDialog(context);
        return false;
      }
    } catch (e) {
      showRetryDialog(context);
      return false;
    }
  }

  void showRetryDialog(BuildContext context) {
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
          title: const Text("Error"),
          content: const Text("Something went wrong try again later."),
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
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Column(
        children: [
          GreyBoxContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Payments',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Table(
              children: [
                TableRow(
                  children: [
                    const CustomTableCell(content: Text('Order fee')),
                    CustomTableCell(content: Text('RM ${widget.order.price}')),
                  ],
                ),
                TableRow(
                  children: [
                    const CustomTableCell(content: Text('Your Commission')),
                    CustomTableCell(
                        content: Text((commission != null)
                            ? 'RM ${(widget.order.price * commission).toStringAsFixed(2)}'
                            : '')),
                  ],
                ),
                const TableRow(
                  children: [
                    CustomTableCell(content: Text('Payment Method')),
                    CustomTableCell(content: Text('Cash Payment')),
                  ],
                ),
                TableRow(
                  children: [
                    const CustomTableCell(content: Text('Payment Status')),
                    CustomTableCell(content: Text(paymentStatus)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FlatButton.icon(
            onPressed: loading
                ? null
                : () async {
                    setState(() {
                      loading = true;
                    });

                    final success = await addPayment(context);

                    if (success) {
                      model.notifyPaid();
                    } else {
                      setState(() {
                        loading = false;
                      });
                    }
                  },
            icon: const Icon(Icons.payment),
            color: Colors.grey[300],
            label: const Text('Add Payment'),
          ),
        ],
      ),
    );
  }
}

class CustomTableCell extends StatelessWidget {
  final Widget content;

  const CustomTableCell({Key key, @required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: SizedBox(
        height: 25,
        child: content,
      ),
    );
  }
}

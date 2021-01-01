import 'package:delivery_courier_app/model/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import 'GreyBoxContainer.dart';

class PaymentSection extends StatefulWidget {
  const PaymentSection({
    Key key,
    @required this.price,
    @required this.user,
  }) : super(key: key);

  final double price;
  final User user;

  @override
  _PaymentSectionState createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  String paymentStatus = "Pending";
  double commission;
  final getCourierCommissionPath =
      "${Constant.serverName}api/couriers/commission/";

  @override
  void initState() {
    super.initState();
    readCourierCommission().then((c) {
      if (mounted) {
        setState(() {
          commission = c;
        });
      }
    });
  }

  Future<double> readCourierCommission() async {
    try {
      var res = await http.get(
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
      print("fail to get commission");
      return null;
    }
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
              children: [
                Text(
                  'Payments',
                  style: const TextStyle(
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
                    CustomTableCell(content: Text('Order fee')),
                    CustomTableCell(content: Text('RM ${widget.price}')),
                  ],
                ),
                TableRow(
                  children: [
                    CustomTableCell(content: Text('Your Commission')),
                    CustomTableCell(
                        content: Text((commission != null)
                            ? 'RM ${widget.price * commission}'
                            : '')),
                  ],
                ),
                TableRow(
                  children: [
                    CustomTableCell(content: Text('Payment Method')),
                    CustomTableCell(content: Text('Cash Payment')),
                  ],
                ),
                TableRow(
                  children: [
                    CustomTableCell(content: Text('Payment Status')),
                    CustomTableCell(content: Text(paymentStatus)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          FlatButton.icon(
            onPressed: () {},
            icon: Icon(Icons.payment),
            color: Colors.grey[300],
            label: Text('Add Payment'),
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

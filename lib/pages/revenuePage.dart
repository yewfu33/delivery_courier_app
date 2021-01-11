import 'dart:convert';

import 'package:delivery_courier_app/model/paymentHistoryModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:delivery_courier_app/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constant.dart';

class RevenuePage extends StatefulWidget {
  final User user;

  const RevenuePage({Key key, @required this.user}) : super(key: key);

  @override
  _RevenuePageState createState() => _RevenuePageState();
}

class _RevenuePageState extends State<RevenuePage> {
  final _revenuePath = "${Constant.serverName}api/couriers/revenue/";
  double amount = 0;
  List<PaymentHistoryModel> paymentHistoryList = [];

  @override
  void initState() {
    super.initState();
  }

  Future fetchRevenue() async {
    try {
      final http.Response res =
          await http.get("$_revenuePath${widget.user.id}", headers: {
        "authorization": "Bearer ${widget.user.token}",
        "content-type": "application/json",
      });

      if (res.statusCode == 200) {
        final resBody = json.decode(res.body);
        amount = resBody["totalEarn"] as double;
        final payments = resBody["payments"] as List;
        paymentHistoryList = payments
            .map<PaymentHistoryModel>(
                (e) => PaymentHistoryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception("Something went wrong when getting data.");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Revenue"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.cached, color: Colors.white),
          )
        ],
        elevation: 0,
      ),
      body: FutureBuilder(
        future: fetchRevenue(),
        builder: (_, snapshot) {
          Widget _totalEarn;
          Widget _paymentHistory;

          if (snapshot.connectionState == ConnectionState.waiting) {
            _totalEarn = Loading();
            _paymentHistory = Center(child: Loading());
          } else {
            if (snapshot.hasError) {
              _totalEarn = Loading();
              _paymentHistory = Center(
                  child: Text(
                snapshot.error.toString(),
                style: const TextStyle(fontSize: 12),
              ));
            } else {
              _totalEarn = Text(
                "RM $amount",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 37,
                  fontWeight: FontWeight.w500,
                ),
              );
              _paymentHistory = Container(
                padding: const EdgeInsets.only(bottom: 15, left: 14, right: 14),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: paymentHistoryList.length,
                  itemBuilder: (_, i) {
                    return PaymentHistoryList(
                        paymentHistoryModel: paymentHistoryList[i]);
                  },
                  separatorBuilder: (_, i) {
                    return const Divider(color: Colors.transparent, height: 11);
                  },
                ),
              );
            }
          }
          return Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  color: Constant.primaryColor,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Total Earn',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      _totalEarn,
                      const SizedBox(height: 5),
                      FlatButton(
                        onPressed: () {},
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: const Text(
                          'Details',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          padding: const EdgeInsets.only(
                              top: 15, left: 14, right: 14),
                          width: double.infinity,
                          child: const Text(
                            "Payment History",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _paymentHistory,
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class PaymentHistoryList extends StatelessWidget {
  const PaymentHistoryList({
    Key key,
    @required this.paymentHistoryModel,
  }) : super(key: key);

  final PaymentHistoryModel paymentHistoryModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 18),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "#${paymentHistoryModel.orderId}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('dd MMM yyyy')
                      .format(paymentHistoryModel.createdOn),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Amount",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                "RM ${paymentHistoryModel.amount}",
                style: const TextStyle(
                    fontSize: 14.5, color: Constant.primaryColor),
              ),
            ],
          ),
          const SizedBox(width: 24),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Earn",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                "RM ${paymentHistoryModel.courierPay.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 14.5, color: Constant.primaryColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

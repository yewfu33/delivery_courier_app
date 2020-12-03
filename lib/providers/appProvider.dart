import 'dart:convert';
import 'dart:io';

import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../constant.dart';

class AppProvider extends ChangeNotifier {
  Future<List<OrderModel>> _orders;

  final User user;

  get orders => _orders;

  AppProvider.user({@required this.user}) {
    this.initOrder();
  }

  void initOrder() {
    _orders = getAllOrders().then((res) {
      if (res == null) throw Exception('failed to fetch pick order');
      print(res.statusCode.toString());

      if (res.statusCode == 200) {
        return Future.value(_setOrderModel(res.body));
      } else {
        print(res.body);
        return Future.value(null);
      }
    }).catchError((err) {
      print(err);
      Future.value(null);
    });
  }

  Future<http.Response> getAllOrders() async {
    try {
      return await http.get(
        Constant.serverName + Constant.orderPath,
      );
    } on SocketException catch (e) {
      print("socket exception in \"getAllOrders\", " + e.toString());
      return null;
    } catch (e) {
      return null;
    }
  }

  List<OrderModel> _setOrderModel(String jsonBody) {
    List<dynamic> body = json.decode(jsonBody);
    return body.map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<List<OrderModel>> fetchOrders() async {
    try {
      http.Response res = await getAllOrders();
      if (res == null) throw Exception('failed to fetch pick order');
      print(res.statusCode.toString());

      if (res.statusCode == 200) {
        return _setOrderModel(res.body);
      } else {
        print(res.body);
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  static void showRetryDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Constant.primaryColor,
          ),
        ),
        child: AlertDialog(
          title: Text("Error occured"),
          content: Text("Please try again later"),
          actions: [
            FlatButton(
              onPressed: () {
                popScreen(context);
              },
              child: Text('OK'),
            )
          ],
        ),
      ),
    );
  }

  static void openCustomDialog(
      BuildContext context, String title, String content, bool isPop) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light().copyWith(
            primary: Constant.primaryColor,
          ),
        ),
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FlatButton(
                onPressed: () {
                  if (isPop) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/', (route) => false);
                  }
                },
                child: Text('OK'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

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

  get orders => _orders;

  final User user;

  AppProvider.user({@required this.user});

  Stream<List<OrderModel>> ordersStream() async* {
    try {
      var res = await getAllOrders();

      if (res.statusCode == 200) {
        yield _setOrderModel(res.body);
      } else {
        print(res.body);
        yield null;
      }
    } catch (e) {
      print(e);
      yield null;
    }
  }

  Future<http.Response> getAllOrders() async {
    try {
      var res = await http.get(
        Constant.serverName + Constant.orderPath,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      return res;
    } on SocketException catch (e) {
      print(
          "socket exception in \"${Constant.serverName + Constant.orderPath}\", " +
              e.toString());
      throw Exception('failed to fetch pick order');
    } catch (e) {
      throw Exception('failed to fetch pick order');
    }
  }

  List<OrderModel> _setOrderModel(String jsonBody) {
    var body = json.decode(jsonBody);
    return body.map<OrderModel>((e) => OrderModel.fromJson(e)).toList();
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

  static void showRetryDialog(BuildContext context,
      {String message = "Please try again later"}) {
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
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: () {
                popScreen(_);
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
                    Navigator.of(_).pop();
                  } else {
                    Navigator.of(_)
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

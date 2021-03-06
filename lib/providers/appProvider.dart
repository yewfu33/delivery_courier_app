import 'dart:convert';
import 'dart:io';

import 'package:delivery_courier_app/helpers/screen_navigation.dart';
import 'package:delivery_courier_app/model/orderModel.dart';
import 'package:delivery_courier_app/model/user.dart';
import 'package:http/io_client.dart' as http;
import 'package:http/http.dart';
import 'package:flutter/material.dart';

import '../constant.dart';

class AppProvider {
  Future<List<OrderModel>> _orders;

  Future<List<OrderModel>> get orders => _orders;

  final User user;
  http.IOClient httpClient;

  AppProvider.user({@required this.user}) {
    // wrap with ioclient to handle connection timeout
    httpClient = http.IOClient(
        HttpClient()..connectionTimeout = const Duration(seconds: 15));
  }

  Stream<List<OrderModel>> ordersStream() async* {
    try {
      final res = await getAllOrders();

      if (res.statusCode == 200) {
        yield _setOrderModel(res.body);
      } else {
        yield null;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> getAllOrders() async {
    try {
      final res = await httpClient.get(
        Constant.serverName + Constant.orderPath,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      return res;
    } on SocketException {
      throw Exception('Make sure device is connected with the internet');
    } catch (e) {
      throw Exception('Failed to fetch order, try again later');
    }
  }

  List<OrderModel> _setOrderModel(String jsonBody) {
    final List body = json.decode(jsonBody) as List;
    return body
        .map<OrderModel>((e) => OrderModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<OrderModel>> fetchOrders() async {
    try {
      final Response res = await getAllOrders();
      if (res == null) throw Exception('failed to fetch pick order');

      if (res.statusCode == 200) {
        return _setOrderModel(res.body);
      } else {
        return null;
      }
    } catch (e) {
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
          colorScheme: const ColorScheme.light().copyWith(
            primary: Constant.primaryColor,
          ),
        ),
        child: AlertDialog(
          title: const Text("Error occured"),
          content: Text(message),
          actions: [
            FlatButton(
              onPressed: () {
                popScreen(_);
              },
              child: const Text('OK'),
            )
          ],
        ),
      ),
    );
  }

  static void openCustomDialog(
      BuildContext context, String title, String content,
      {bool isPop}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light().copyWith(
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
                child: const Text('OK'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

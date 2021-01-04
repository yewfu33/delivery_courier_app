import 'package:flutter/foundation.dart';

class PaymentModel {
  final double amount;
  final double courierPay;
  final int orderId;
  final int userId;
  final int courierId;

  PaymentModel({
    @required this.amount,
    @required this.courierPay,
    @required this.orderId,
    @required this.courierId,
    @required this.userId,
  });

  Map toMap() => {
        'amount': amount,
        'courier_pay': courierPay,
        'order_id': orderId,
        'user_id': userId,
        'courier_id': courierId,
      };
}

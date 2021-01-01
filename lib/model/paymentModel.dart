import 'package:flutter/foundation.dart';

class PaymentModel {
  final double amount;
  final double courierPay;
  final int orderId;
  final int userId;
  final int courierId;
  final int paymentMethod = 0;
  final int courierPaymentStatus = 0;

  PaymentModel({
    @required this.amount,
    @required this.courierPay,
    @required this.orderId,
    @required this.courierId,
    @required this.userId,
  });
}

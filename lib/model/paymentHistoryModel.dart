class PaymentHistoryModel {
  final double amount;
  final double courierPay;
  final int orderId;
  final DateTime createdOn;

  PaymentHistoryModel.fromJson(Map<String, dynamic> json)
      : amount = json['amount'] as double,
        courierPay = json['courier_pay'] as double,
        orderId = json['order_id'] as int,
        createdOn = DateTime.parse(json['created_at'] as String);
}

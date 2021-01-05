import 'package:delivery_courier_app/model/dropPointModel.dart';
import 'package:delivery_courier_app/model/userModel.dart';

import 'enum.dart';

class OrderModel {
  final int orderId;
  final String name;
  final double weight;
  final String address;
  final double latitude;
  final double longitude;
  final String comment;
  final String contact;
  final DateTime dateTime;
  final double price;
  final int vehicleType;
  final DeliveryStatus status;
  final int userId;
  final DateTime createdAt;
  final List<DropPointModel> dropPoint;
  final UserModel user;

  OrderModel.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'] as int,
        name = json['name'] as String,
        address = json['pick_up_address'] as String,
        latitude = json['latitude'] as double,
        longitude = json['longitude'] as double,
        weight = json['weight'] as double,
        comment = json['comment'] as String,
        contact = json['contact_num'] as String,
        dateTime = DateTime.parse(json['pick_up_datetime'] as String),
        price = json['price'] as double,
        status = DeliveryStatus.values[json['delivery_status'] as int],
        vehicleType = json['vehicle_type'] as int,
        createdAt = DateTime.parse(json['created_at'] as String),
        userId = json['user_id'] as int,
        user = UserModel.fromJson(json['user'] as Map<String, dynamic>),
        dropPoint = List.from(json['drop_points'] as List)
            .map((dp) => DropPointModel.fromJson(dp as Map<String, dynamic>))
            .toList();

  Map toMap() {
    List<Map> dp;
    if (dropPoint != null) {
      dp = dropPoint.map((i) => i.toMap()).toList();
    } else {
      dp = null;
    }

    return {
      'order_id': orderId,
      'name': name,
      'weight': weight,
      'pick_up_address': address,
      'latitude': latitude,
      'longitude': longitude,
      'comment': comment,
      'contact_num': contact,
      'pick_up_datetime': dateTime,
      'price': price,
      'delivery_status': status.index,
      'vehicle_type': vehicleType,
      'user_id': userId,
      'created_at': createdAt,
      'drop_points': dp,
    };
  }
}

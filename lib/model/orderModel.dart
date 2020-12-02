import 'package:delivery_courier_app/model/dropPointModel.dart';
import 'package:delivery_courier_app/model/userModel.dart';

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
  final int status;
  final int userId;
  final DateTime createdAt;
  final List<DropPointModel> dropPoint;
  final UserModel user;

  OrderModel.fromJson(Map<String, dynamic> json)
      : orderId = json['order_id'],
        name = json['name'],
        address = json['pick_up_address'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        weight = json['weight'],
        comment = json['comment'],
        contact = json['contact_num'],
        dateTime = DateTime.parse(json['pick_up_datetime']),
        price = json['price'],
        status = json['delivery_status_id'],
        vehicleType = json['vehicle_type_id'],
        createdAt = DateTime.parse(json['created_at']),
        userId = json['user_id'],
        user = UserModel.fromJson(json['user']),
        dropPoint = List<DropPointModel>.from(json['drop_points']
            .map((dp) => DropPointModel.fromJson(dp))
            .toList());

  Map toMap() {
    List<Map> dp = this.dropPoint != null
        ? this.dropPoint.map((i) => i.toMap()).toList()
        : null;

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
      'delivery_status_id': status,
      'vehicle_type_id': vehicleType,
      'user_id': userId,
      'created_at': createdAt,
      'drop_points': dp,
    };
  }
}

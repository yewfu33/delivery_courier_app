class DropPointModel {
  final int dropPointId;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime dateTime;
  final String contact;
  final String comment;

  DropPointModel.fromJson(Map<String, dynamic> json)
      : dropPointId = json['drop_point_id'] as int,
        address = json['address'] as String,
        latitude = json['latitude'] as double,
        longitude = json['longitude'] as double,
        contact = json['contact_num'] as String,
        dateTime = DateTime.parse(json['datetime'] as String),
        comment = json['comment'] as String;

  Map toMap() => {
        'drop_point_id': dropPointId,
        'address': address,
        'latitude': latitude,
        'longitude': longitude,
        'contact_num': contact,
        'datetime': dateTime,
        'comment': comment,
      };
}

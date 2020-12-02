class DropPointModel {
  final int dropPointId;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime dateTime;
  final String contact;
  final String comment;

  DropPointModel.fromJson(Map<String, dynamic> json)
      : dropPointId = json['drop_point_id'],
        address = json['address'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        contact = json['contact_num'],
        dateTime = DateTime.parse(json['datetime']),
        comment = json['comment'];

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

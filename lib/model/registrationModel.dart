import 'document.dart';

class RegistrationModel {
  String name;
  String phoneNum;
  String email;
  String profilePicture;
  String profilePictureName;
  int vehicleType;
  String vehiclePlateNo;
  List<Document> documents = new List<Document>();

  Map toMap() {
    List<Map> d = this.documents != null
        ? this.documents.map((i) => i.toMap()).toList()
        : null;

    return {
      'name': name,
      'phone_num': phoneNum,
      'email': email,
      'vehicle_plate_no': vehiclePlateNo,
      'profile_picture': profilePicture,
      'profile_picture_name': profilePictureName,
      'documents': d,
      'vehicle_type': vehicleType,
    };
  }
}

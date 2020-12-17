class UserModel {
  final int userId;
  final String name;
  final String phoneNum;
  final String fcmToken;

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'],
        name = json['name'],
        phoneNum = json['phone_num'],
        fcmToken = json['fcm_token'];
}

class UserModel {
  final int userId;
  final String name;
  final String phoneNum;
  final String fcmToken;

  UserModel.fromJson(Map<String, dynamic> json)
      : userId = json['user_id'] as int,
        name = json['name'] as String,
        phoneNum = json['phone_num'] as String,
        fcmToken = json['fcm_token'] as String;
}

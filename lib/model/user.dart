class User {
  int id;
  String name;
  String phoneNum;
  String token;
  String email;
  String profilePic;
  bool onBoard;

  User();

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        phoneNum = json['phone_num'] as String,
        email = json['email'] as String,
        profilePic = json['profile_pic'] as String,
        token = json['token'] as String,
        onBoard = json['onBoard'] as bool;
}

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
      : id = json['id'],
        name = json['name'],
        phoneNum = json['phone_num'],
        email = json['email'],
        profilePic = json['profile_pic'],
        token = json['token'],
        onBoard = json['onBoard'];
}

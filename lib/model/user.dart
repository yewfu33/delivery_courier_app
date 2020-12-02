class User {
  int id;
  String name;
  String phoneNum;
  String token;
  bool onBoard;

  User();

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        phoneNum = json['phone_num'],
        token = json['token'],
        onBoard = json['onBoard'];
}

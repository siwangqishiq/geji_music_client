import 'dart:convert';

class User {
  int uid = -1;
  String? nickname;

  User({this.uid = -1,this.nickname});

  factory User.fromJson(String jsonStr){
    var jsonMap = jsonDecode(jsonStr);
    return User(
      uid: jsonMap["uid"]??-1,
      nickname: jsonMap["nickname"],
    );
  }
}
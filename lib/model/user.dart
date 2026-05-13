import 'dart:convert';

class User {
  int uid = -1;

  User({this.uid = -1});

  factory User.fromJson(String jsonStr){
    var jsonMap = jsonDecode(jsonStr);
    return User(
      uid: jsonMap["uid"]??-1
    );
  }
}
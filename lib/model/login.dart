
import 'dart:convert';

class LoginResp {
  int? uid = -1;
  String? nickname;
  String? avatar;
  String? account;
  String? age;
  String? remark;
  String? token;

  LoginResp({this.token,this.uid = -1,this.nickname,this.avatar,this.account, this.age,this.remark});

  Map<String,dynamic> encode(){
    var resultMap = <String,dynamic>{
      "uid":uid,
      "nickname":nickname,
      "avatar":avatar,
      "account":account,
      "age":age,
      "remark":remark,
      "token":token
    };
    return resultMap;
  }

  factory LoginResp.fromJson(String jsonStr){
    var jsonMap = jsonDecode(jsonStr);
    return LoginResp.fromMap(jsonMap);
  }

  factory LoginResp.fromMap(Map<String,dynamic> jsonMap){
    return LoginResp(
      uid: jsonMap["uid"]??-1,
      nickname: jsonMap["nickname"],
      avatar: jsonMap["avatar"],
      account: jsonMap["account"],
      age: jsonMap["age"],
      remark: jsonMap["remark"],
      token: jsonMap["token"]
    );
  }
}
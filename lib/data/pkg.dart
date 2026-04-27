import 'package:geji_music_client/data/codes.dart';

class Resp<T> {
  int? code;
  String? msg;
  T? data;

  Resp({this.code,this.msg,this.data});

  static Resp fail(int code, String msg) {
    return Resp(code:code, msg :msg);
  }
  
  static Resp success<T>(T data){
    return Resp(code: CODE_SUCCESS, data:data);
  }
}




import 'dart:convert';

import 'package:geji_music_client/data/keys.dart';
import 'package:geji_music_client/model/user.dart';
import 'package:geji_music_client/util/log.dart';
import 'package:geji_music_client/util/text_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account{
  static Account? _instance;

  static Account instance() {
    if(_instance == null){
      _instance = Account();
      _instance?._init();
    }  
    return _instance!;
  }

  String? _token;
  String? getToken() => _token;

  User? _user;
  User? getUserInfo() => _user;

  void _init(){
    Log.i("account", "init account");
  }

  Future<bool> saveToken(String? token) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(TextUtil.isEmpty(token)){
      var result = await prefs.remove(Keys.TOKEN);
      _token = null;
      return result;
    }

    var result = await prefs.setString(Keys.TOKEN, token!);
    Log.i("account", "save token:$token result $result");
    _token = token;
    return result;
  }

  Future<bool> saveUser(User? user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if(user == null){
      var result = await prefs.remove(Keys.USER_INFO);
      _user = null;
      return result;
    }

    var userEncodeStr = jsonEncode(user.encode());
    var result = await prefs.setString(Keys.USER_INFO, userEncodeStr);
    Log.i("account", "save user:$userEncodeStr result $result");
    _user = user;
    return result;
  }

  Future<void> load() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // final asyncPrefs = SharedPreferencesAsync();
    _token = prefs.getString(Keys.TOKEN);
    Log.i("account", "read token:$_token");

    var userJson = prefs.getString(Keys.USER_INFO);
    Log.i("account", "read userJson:$userJson");
    if(TextUtil.isNotEmpty(userJson)){
      _user = User.fromJson(userJson??"{}");
    }
  }

  bool isLogined() {
    return TextUtil.isNotEmpty(_token) && ((_user?.uid??-1) > 0);
  }

  String accountDisplayName(){
    if(_user == null){
      return "";
    }

    if(TextUtil.isNotEmpty(_user?.nickname)){
      return _user?.nickname??"";
    }

    return "${_user?.uid}";
  }
  
}//end class
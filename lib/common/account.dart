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
  String? getToken(){
    return _token;
  }

  User? _user;

  void _init(){
    Log.i("account", "init account");
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
}
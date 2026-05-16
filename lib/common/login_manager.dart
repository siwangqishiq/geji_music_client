import 'package:geji_music_client/common/account.dart';
import 'package:geji_music_client/common/eventbus/bus_msg.dart';
import 'package:geji_music_client/common/eventbus/event_bus.dart';
import 'package:geji_music_client/data/message_types.dart';
import 'package:geji_music_client/model/user.dart';

class LoginManager {
  static LoginManager? _instance;

  static LoginManager instance() {
    return _instance??LoginManager();
  }

  Future<bool> saveLoginData(String? token, User? user) async{
    var saveTokenResult = await Account.instance().saveToken(token);
    var saveUserResult = await Account.instance().saveUser(user);
    bool result = saveTokenResult && saveUserResult;
    if(result){
      EventBus.instance().postEvent(EventMessage(MessageTypes.LOGIN_SUCCESS));
    }
    return result;
  } 

  Future<void> clearLoginData() async{
    await Account.instance().saveToken(null);
    await Account.instance().saveUser(null);

    EventBus.instance().postEvent(EventMessage(MessageTypes.PAGE_SETSTATE));
  }
}//end class
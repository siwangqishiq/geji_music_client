

import 'package:geji_music_client/common/eventbus/bus_msg.dart';
import 'package:geji_music_client/util/log.dart';

class EventBus {
  static EventBus? _instance;
  static final String _tag = "EventBus";

  static EventBus instance(){
    _instance ??= EventBus();
    return _instance!;
  }

  final List<IEvent> _list  = [];

  void register(IEvent obj){
    Log.i(_tag, "register obj:$obj");
    if(_list.contains(obj)){
      return;
    }

    _list.add(obj);
    Log.i(_tag, "register obj:$obj success list count ${_list.length}");
  }

  void unRegister(IEvent obj){
    Log.i(_tag, "unregister obj:$obj");
    if(!_list.contains(obj)){
      return;
    }

    var result = _list.remove(obj);
    if(result){
      Log.i(_tag, "un register obj:$obj success list count ${_list.length}");
    }
  }

  //以正常顺序投递消息 即后注册的先收到
  void postEvent(EventMessage msg){
    for(int i = _list.length - 1 ; i >= 0 ; i--){
      bool isCost = _list[i].onEvent(msg);
      if(isCost){
        break;
      }
    }//end for i
  }

  //以相反顺序投递消息 即先注册的先收到
  void postEventReverse(EventMessage msg){
    for(int i = 0; i < _list.length ; i++){
      bool isCost = _list[i].onEvent(msg);
      if(isCost){
        break;
      }
    }//end for i
  }
  
}//end class





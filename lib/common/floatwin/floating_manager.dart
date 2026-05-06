import 'package:flutter/material.dart';
import 'package:geji_music_client/common/floatwin/floating_player.dart';
import 'package:geji_music_client/util/log.dart';

class FloatingManager {
 static final FloatingManager _instance = FloatingManager._();
  factory FloatingManager() => _instance;
  FloatingManager._();

  static GlobalKey<NavigatorState>? navigatorKey;

  OverlayEntry? _entry;

  void show() {
    if (_entry != null) {
      return;
    }

    final overlay = navigatorKey?.currentState?.overlay;
    if (overlay == null) {
      Log.e("FloatWindow", "overlay is null!");
      return;
    }

    _entry = OverlayEntry(
      builder: (context) {
        return const FloatingPlayer();
      },
    );
    overlay.insert(_entry!);
  }

  void hide() {
    _entry?.remove();
    _entry = null;
  }

  bool get isShowing => _entry != null;

  void toggle(){
    if(isShowing){
      hide();
    }else{
      show();
    }
  }
  
}//end class

import 'package:flutter/material.dart';
import 'package:geji_music_client/common/player.dart';

class FloatWinPlayerState extends ChangeNotifier {
  static final FloatWinPlayerState instance = FloatWinPlayerState._();
  FloatWinPlayerState._();

  bool isPlaying = false;
  String coverUrl = "";

  void toggle() {
    if(isPlaying){
      Player().pause();
    }else{
      Player().resume();
    }

    isPlaying = !isPlaying;
    notifyListeners();
  }

  void setCover(String url) {
    coverUrl = url;
    notifyListeners();
  }
}
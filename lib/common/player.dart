import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
// import 'package:geji_music_client/common/web_auido_player.dart';

class Player {
  static final Player _instance = Player._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();

  factory Player() {
    return _instance;
  }

  Player._internal();

  void playUrl(String url) async {
    if (kIsWeb) {
      // WebAudioPlayer().play(url);
    } else {
      if (_audioPlayer.state == PlayerState.playing) {
        _audioPlayer.stop();
      }

      await _audioPlayer.play(UrlSource(url));
    }
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

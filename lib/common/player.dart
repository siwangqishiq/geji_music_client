import 'package:audioplayers/audioplayers.dart';

class Player {
  static final Player _instance = Player._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();

  factory Player() {
    return _instance;
  }

  Player._internal();

  void playUrl(String url) async {
    if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.stop();
    }

    await _audioPlayer.play(UrlSource(url));
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

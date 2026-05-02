import 'dart:html' as html;

class WebAudioPlayer {
  static final WebAudioPlayer _instance = WebAudioPlayer._internal();

  factory WebAudioPlayer() {
    return _instance;
  }

  WebAudioPlayer._internal();

  html.AudioElement? _audio;

  void play(String url) {
    _audio?.pause();
    _audio = html.AudioElement()
      ..src = url
      ..autoplay = true;

    _audio!.play();
  }

  void pause() {
    _audio?.pause();
  }
}

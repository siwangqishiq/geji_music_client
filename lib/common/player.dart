import 'package:audioplayers/audioplayers.dart';
import 'package:geji_music_client/common/floatwin/floating_manager.dart';
import 'package:geji_music_client/common/floatwin/player_state.dart';
import 'package:geji_music_client/model/music.dart';
import 'package:geji_music_client/util/log.dart';
import 'package:geji_music_client/util/toast_util.dart';
// import 'package:geji_music_client/common/web_auido_player.dart';

class Player {
  static final Player _instance = Player._internal();
  final AudioPlayer _audioPlayer = AudioPlayer();

  factory Player() {
    return _instance;
  }

  Player._internal();

  final List<Music> _musicList = [];
  int _currentIndex = -1;

  void playMusic(Music music){
    String musicUrl = music.playUrl??"";
    Log.i("player", "musicUrl $musicUrl");

    playUrl(musicUrl);
    FloatWinPlayerState.instance.isPlaying = true;
    FloatWinPlayerState.instance.setCover(music.cover??"");
    FloatingManager().show();
  }

  void addMusic(Music music){
    _musicList.add(music);
    if(_currentIndex < 0){
      _currentIndex = 0;
    }
  }

  void playUrl(String url) async {
    if (_audioPlayer.state == PlayerState.playing) {
      _audioPlayer.stop();
    }

    _addPlayListener();
    try{
      await _audioPlayer.play(UrlSource(url));
    }catch(e){
      Log.e("player", "play error ${e.toString()}");
      ToastUtil.showAsError("播放异常");
    }
  }

  void _addPlayListener(){
    _audioPlayer.onPlayerStateChanged.listen((playState){
      Log.i("player", "music player state change $playState");
      if(playState == PlayerState.playing){
        // FloatWinPlayerState.instance.isPlaying = true;
      }if(playState == PlayerState.completed){
        //todo 判断播放模式
        switchToNextMusic();
      }else{
        // FloatWinPlayerState.instance.isPlaying = false;
      }
    });
    

  }

  void switchToNextMusic(){
    Log.i("player", "switch to next music");
    if(_musicList.isEmpty) {
      Log.i("player", "music list is empty");
      return;
    }

    _currentIndex = (_currentIndex + 1) % _musicList.length;
    Log.i("player", "play index = $_currentIndex");
    var music = _musicList[_currentIndex];
    playMusic(music);
  }

  void pause() {
    Log.i("player", "player pause ${_audioPlayer.state}");
    if (_audioPlayer.state == PlayerState.playing) {
        Log.i("player", "player real pause");
        _audioPlayer.pause();
    }
  }

  void resume() {
    Log.i("player", "player resume");
    _audioPlayer.resume();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

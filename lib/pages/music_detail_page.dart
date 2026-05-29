// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geji_music_client/common/com_color.dart';
import 'package:geji_music_client/common/eventbus/bus_msg.dart';
import 'package:geji_music_client/common/eventbus/event_bus.dart';
import 'package:geji_music_client/common/http_client.dart';
import 'package:geji_music_client/common/player.dart';
import 'package:geji_music_client/data/message_types.dart';
import 'package:geji_music_client/model/music.dart';
import 'package:geji_music_client/pages/toobar_action_widget.dart';
import 'package:geji_music_client/util/log.dart';
import 'package:geji_music_client/util/time_util.dart';
import 'package:geji_music_client/util/toast_util.dart';

class MusicDetailPage extends StatefulWidget {
  final String mid;

  const MusicDetailPage({super.key, required this.mid});

  @override
  State<StatefulWidget> createState() => _MusicDetailPageState();
} //end class

class _MusicDetailPageState extends State<MusicDetailPage> with IEvent {
  static String Tag = "MusicDetailPage";

  bool _isLoading = true;
  Music? _musicData;

  @override
  void initState() {
    super.initState();
    EventBus.instance().register(this);
    _requestMusicDetail();
  }

  @override
  void dispose(){
    EventBus.instance().unRegister(this);
    super.dispose();
  }

  void _requestMusicDetail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var resp = await HttpClient().get<Music?>(
        "/api/detail",
        params: {"mid": widget.mid},
        parser: (json) => Music.fromJson(json),
      );
      Log.i(Tag, "resp ${resp.code}");
      if (resp.isSuccess()) {
        Log.w(Tag, "Get detail result : ${resp.data?.name}");
        _musicData = resp.data;
        _isLoading = false;
      } else {
        ToastUtil.showAsError(resp.msg ?? "请求详情错误");
      }
    } catch (e, stackTrace) {
      Log.e(Tag, "Error request $e");
      Log.e(Tag, "Error stackTrace $stackTrace");
      ToastUtil.showAsError("请求错误");
    }

    setState(() {});
  }

  void _playMusic(Music? music) {
    if (music == null) {
      return;
    }

    Player().playMusic(music);
  }

  Future<void> _addToMyFavor() async {
    if(_musicData == null) {
      return;
    }

    Log.i(Tag, "add music mid ${_musicData?.mid} ${_musicData?.name} to favor");
    try {
      var resp = await HttpClient().get<Music?>(
        "/api/detail",
        params: {"mid": widget.mid},
        parser: (json) => Music.fromJson(json),
      );
      Log.i(Tag, "resp ${resp.code}");
      if (resp.isSuccess()) {
        Log.w(Tag, "Get detail result : ${resp.data?.name}");
        _musicData = resp.data;
        _isLoading = false;
      } else {
        ToastUtil.showAsError(resp.msg ?? "请求详情错误");
      }
    } catch (e, stackTrace) {
      Log.e(Tag, "Error request $e");
      Log.e(Tag, "Error stackTrace $stackTrace");
      ToastUtil.showAsError("请求错误");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ComColors.MainBackground,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 8,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        // actions: [
        //   BuildToolbarActionWidget(context),
        // ],
      ),
      body: SafeArea(
        child: (_isLoading || _musicData == null)
            ? _buildLoadingWidget()
            : _buildDetailWidget(),
      ),
    );
  }

  Widget _buildDetailWidget() {
    return Align(
      alignment: Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(25),
              child: Image.network(
                _musicData?.cover ?? "",
                width: 180,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildFallbackCover();
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _musicData?.name ?? "",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _musicData?.author ?? "",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(height: 4),
          Text(
            TimeUtil.formatDuration(_musicData?.durationSecs ?? 0),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),

          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Log.i(Tag, "play music url ${_musicData?.playUrl}");
                  // ToastUtil.show("开始播放${_musicData?.name}");
                  _playMusic(_musicData);
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  fixedSize: const Size(90, 50),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("播放", style: TextStyle(fontSize: 16)),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // ToastUtil.showAsError("请先登录");
                  // FloatingManager().toggle();
                  _addToMyFavor();
                },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  fixedSize: const Size(180, 50),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                ),
                child: const Text("加入收藏", style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackCover(){
    return Container(
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.music_note,
          size: 48,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: SizedBox(
        key: ValueKey("detail_loading"),
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 4,
          color: ThemeData.light().focusColor,
        ),
      ),
    );
  }

  @override
  bool onEvent(EventMessage msg) {
    switch(msg.what){
      case MessageTypes.PAGE_SETSTATE:
       setState(() {});
        break;
      case MessageTypes.LOGIN_SUCCESS:
       setState(() {});
        break;
    }
    return false;
  }
}

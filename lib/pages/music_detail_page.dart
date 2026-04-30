// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geji_music_client/common/http_client.dart';
import 'package:geji_music_client/model/music.dart';
import 'package:geji_music_client/util/log.dart';
import 'package:geji_music_client/util/time_util.dart';
import 'package:geji_music_client/util/toast_util.dart';

class MusicDetailPage extends StatefulWidget {
  final String mid;

  const MusicDetailPage({super.key, required this.mid});
  
  @override
  State<StatefulWidget> createState() => _MusicDetailPageState();
}//end class

class _MusicDetailPageState extends State<MusicDetailPage>{
  static String Tag = "MusicDetailPage";

  bool _isLoading = false;
  Music? _musicData;

  @override
  void initState() {
    super.initState();
    _requestMusicDetail();
  }

  void _requestMusicDetail() async{
    setState(() {
      _isLoading = true;  
    });

    try{
      var resp = await HttpClient().get<Music?>("/api/detail",
        params: {
          "mid":widget.mid
        },
        parser: (json)=> Music.fromJson(json)
      );
      Log.i(Tag, "resp ${resp.code}");
      if(resp.isSuccess()){
        Log.w(Tag, "Get detail result : ${resp.data?.name}");
        _musicData = resp.data;
        _isLoading = false;
      }else{
        ToastUtil.showAsError(resp.msg??"请求详情错误");
      }
    }catch(e, stackTrace) {
      Log.e(Tag, "Error request $e");
      Log.e(Tag, "Error stackTrace $stackTrace");
      ToastUtil.showAsError("请求错误");
    }

    setState(() {
      
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 4,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: (_isLoading && _musicData != null)?_buildLoadingWidget():_buildDetailWidget()
      ),
    );
  }

  Widget _buildDetailWidget(){
    return Align(
      alignment:Alignment.topCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 16),
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 25,
                  spreadRadius: 2,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child:ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(25),
              child: Image.network(
                _musicData?.cover??"",
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            _musicData?.name??"",
            style: TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 8),
          Text(
            _musicData?.author??"",
            style: TextStyle(color: Colors.grey,fontSize: 16, fontWeight: FontWeight.normal)
          ),
          SizedBox(height: 4),
          Text(
            TimeUtil.formatDuration(_musicData?.durationSecs??0),
            style: TextStyle(color: Colors.grey,fontSize: 16, fontWeight: FontWeight.normal)
          ),
        ],
      )
    );
  }

  Widget _buildLoadingWidget(){
    return Center(
      child: SizedBox(
        key: ValueKey("detail_loading"),
        width: 32,
        height: 32,
        child: CircularProgressIndicator(strokeWidth: 4,color:ThemeData.light().focusColor),
      )
    );
  }
}



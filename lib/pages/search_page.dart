// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geji_music_client/common/com_color.dart';
import 'package:geji_music_client/common/eventbus/bus_msg.dart';
import 'package:geji_music_client/common/eventbus/event_bus.dart';
import 'package:geji_music_client/common/http_client.dart';
import 'package:geji_music_client/util/log.dart';
import 'package:geji_music_client/util/text_util.dart';
import 'package:geji_music_client/util/toast_util.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with IEvent {
  static String Tag = "SearchPage";

  final _inputController = TextEditingController();
  bool _isLoading = false;
  bool _searchButtonEnable = false;
  String? respContent;

  @override
  void initState() {
    super.initState();
    EventBus.instance().register(this);
  }

  @override
  void dispose(){
    EventBus.instance().unRegister(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:ComColors.MainBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            children: [
              buildSearchBarWidget(),
              SizedBox(height: 8),
              Expanded(
                child: Text(respContent??"")
              )
            ],
          ),
        ),
      )
    );
  }

  void _searchButtonClick() async {
    Log.i(Tag, "click search button.");
    // ToastUtil.show("开始搜索${_inputController.text}");
    var queryContent = _inputController.text;
    Log.i(Tag, "query : $queryContent");

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    try{
      var resp = await HttpClient().get<String>("/api/search",params: {
        "query":queryContent
      });
      Log.i(Tag, "resp ${resp.statusCode} ${resp.data}");
      respContent = resp.data;
    }catch(e, stackTrace) {
      Log.e(Tag, "Error request $e");
      Log.e(Tag, "Error stackTrace $stackTrace");
      ToastUtil.show("请求错误");
    }

    setState(() {
      _isLoading = false;
    });
  }

  Widget buildSearchBarWidget(){
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100, // 搜索框背景色
          borderRadius: BorderRadius.circular(20), // 圆角
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ]
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _inputController,
                onSubmitted: (content){
                  Log.i(Tag, "submit content $content");
                  if(TextUtil.isNotEmpty(content)){
                    _searchButtonClick();
                  }
                },
                onChanged: (value) {
                  setState(() {
                    _searchButtonEnable = TextUtil.isNotEmpty(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: "搜索歌曲或歌手",
                  hintStyle: TextStyle(color: ThemeData.light().hintColor),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(width: 8),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 320),
              child: _isLoading
                  ? SizedBox(
                      key: ValueKey("loading"),
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2,color:ThemeData.light().focusColor),
                    )
                  : GestureDetector(
                      key: ValueKey("button"),
                      onTap: _searchButtonClick,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _searchButtonEnable?Colors.blue:Colors.blueGrey,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "搜索",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  
  @override
  bool onEvent(EventMessage msg) {
    return false;
  }
}//end class



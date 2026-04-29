// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geji_music_client/common/com_color.dart';
import 'package:geji_music_client/common/eventbus/bus_msg.dart';
import 'package:geji_music_client/common/eventbus/event_bus.dart';
import 'package:geji_music_client/common/http_client.dart';
import 'package:geji_music_client/common/widget/responsive_container.dart';
import 'package:geji_music_client/data/pkg.dart';
import 'package:geji_music_client/model/song.dart';
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

  List<SongQuery> _resultList = [];

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
                child: ResponsiveContainer(
                  maxWidth: 600,
                  child: ListView.builder(
                    itemCount: _resultList.length,
                    itemBuilder: (ctx,index) => buildQueryResultItem(ctx,index)
                  )
                )
              )
            ],
          ),
        ),
      )
    );
  }

  Widget buildQueryResultItem(BuildContext ctx, int index){
    var itemData = _resultList[index];
    return Padding(
      padding: EdgeInsetsGeometry.all(8),
      child: Card(
        elevation: 12, // 阴影强度
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          onTap: () {
            Log.i(Tag, "click item ${itemData.mid} ${itemData.name} ${itemData.author}");
          },
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Text(
                          itemData.name??"*" , 
                          style: TextStyle(color: Colors.black,fontSize: 20, fontWeight: FontWeight.bold)
                      ) 
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      itemData.author??"未知歌手",
                      style: TextStyle(color: Colors.grey,fontSize: 14, fontStyle: FontStyle.normal)
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      )
    );

    // return Container(
    //   margin: EdgeInsets.all(16),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(20),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.grey.withValues(alpha: 0.2),
    //         blurRadius: 25,
    //         spreadRadius: 2,
    //         offset: Offset(0, 8),
    //       ),
    //     ],
    //   ),
    //   child: Padding(
    //     padding: EdgeInsets.all(20),
    //     child: Text("iOS 风格卡片"),
    //   ),
    // );
  }

  void _searchButtonClick() async {
    Log.i(Tag, "click search button.");
    // ToastUtil.show("开始搜索${_inputController.text}");
    var queryContent = _inputController.text;
    Log.i(Tag, "query : $queryContent");

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
      _resultList.clear();
    });

    try{
      var resp = await HttpClient().get<List<SongQuery>?>("/api/search",
        params: {
          "query":queryContent
        },
        parser: (json)=>(json as List).map((e) => SongQuery.fromJson(e)).toList()
      );
      Log.i(Tag, "resp ${resp.code}");
      if(resp.isSuccess()){
        var list = resp.data;
        Log.w(Tag, "Get query result : ${list?.length??0}");
        _resultList.addAll(list??[]);
      }else{
        ToastUtil.showAsError(resp.msg??"请求错误");
      }
    }catch(e, stackTrace) {
      Log.e(Tag, "Error request $e");
      Log.e(Tag, "Error stackTrace $stackTrace");
      ToastUtil.showAsError("请求错误");
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



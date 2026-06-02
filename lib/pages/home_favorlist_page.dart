import 'package:flutter/material.dart';
import 'package:geji_music_client/common/com_color.dart';
import 'package:geji_music_client/common/http_client.dart';
import 'package:geji_music_client/common/player.dart';
import 'package:geji_music_client/common/widget/dialog_helper.dart';
import 'package:geji_music_client/common/widget/favor_item.dart';
import 'package:geji_music_client/common/widget/responsive_container.dart';
import 'package:geji_music_client/model/favor.dart';
import 'package:geji_music_client/util/log.dart';
import 'package:geji_music_client/util/toast_util.dart';
import 'package:toastification/toastification.dart';

class FavorlistPage extends StatefulWidget {
  const FavorlistPage({super.key});
  
  @override
  State<StatefulWidget> createState()=> _FavorPageState();
  
}//end class

class _FavorPageState extends State<FavorlistPage> {

  final List<Favor> _favorList = [];

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _requestFavorList();
  }

  Future<void> _requestFavorList() async{
    setState(() {
      _loading = true;
    });

    try {
      var resp = await HttpClient().get<List<Favor>?>(
        "/api/queryFavor",
        parser: (json) {
          // Log.i("favor", "parse json:${json.runtimeType}");
          List<dynamic> originList = json as List<dynamic>;
          List<Favor> list = [];
          for(dynamic obj in originList){
            Log.i("favor", "obj json:${obj.runtimeType}  c : $obj");
            list.add(Favor.fromJson(obj));
          }
          return list;
        },
      );
      Log.i("favor", "resp ${resp.code}");

      if (resp.isSuccess()) {
        Log.i("favor", "Favor list result : ${resp.data}");
        List<Favor>? favorList = resp.data;
        Log.i("favor", "favor list size ${favorList?.length}");

        _favorList.clear();

        _favorList.addAll(favorList??[]);
      } else {
        ToastUtil.showAsError(resp.msg ?? "请求详情错误");
      }
    } catch (e, _) {
      Log.e("favor", "Error request $e");
      ToastUtil.showAsError("请求错误");
    }

     setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("我的歌单"),
      ),
      backgroundColor: ComColors.MainBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _requestFavorList,
          child: ResponsiveContainer(
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),

                if (_loading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (_favorList.isEmpty)
                  _buildEmpty()
                else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  sliver: SliverList.builder(
                    itemCount: _favorList.length,
                    itemBuilder: (context, index) {
                      return FavorItem(
                        favor: _favorList[index],
                        onClick: (favor) {
                          Log.i("favor", "click favor item ${favor.music?.playUrl}");
                          if(favor.music != null){
                            Player().playMusic(favor.music!);
                          }
                        },
                        onLongClick: (favor) => _onLongClickItem(favor),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  void _onLongClickItem(Favor? favor) {
    DialogHelper.showAlertDialog("移除收藏", "确认将歌曲 ${favor?.music?.name} 移出收藏吗?", context, 
      (){
        Log.i("favor", "click confirm");
        _doRemoveFavor(favor?.fid??-1);
      }, 
      (){
        Log.i("favor", "click cancel button");
      },confirmText: "移除");
  }

  Future<void> _doRemoveFavor(int fid) async {
    Log.i("favor", "remove favor id = $fid");

    try {
      var resp = await HttpClient().post<String?>(
        "/api/removeFavor",
        params: {"fid": fid}
      );
      Log.i("favor", "resp ${resp.code}");

      if (resp.isSuccess()) {
        Log.i("favor", "Remove Favor result : ${resp.data}");
        ToastUtil.show("移除成功~", style: ToastificationStyle.fillColored);

        _requestFavorList();
      } else {
        ToastUtil.showAsError(resp.msg ?? "请求详情错误");
      }
    } catch (e, _) {
      Log.e("favor", "Error request $e");
      ToastUtil.showAsError("请求错误");
    }
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,16,20,24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            "${_favorList.length} 首歌曲",
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.favorite_border,
              size: 72,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              "暂无收藏歌曲",
              style: TextStyle(
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
  
}//end class
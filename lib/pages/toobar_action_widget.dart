// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:geji_music_client/common/account.dart';
import 'package:geji_music_client/common/login_manager.dart';
import 'package:geji_music_client/pages/routers.dart';
import 'package:geji_music_client/util/log.dart';

Widget BuildToolbarActionWidget(BuildContext context){
  final isLogined = Account.instance().isLogined();
  if(isLogined){
    return SizedBox(width: 0);
  }
  return Row(
    children: [
      // isLogined?_buildLoginedWidget(context):
      //   InkWell(
      //     child: Text("登录"),
      //     onTap: (){
      //       Log.i("toolbar", "click login button");
      //       var fromOtherPage = true;
      //       Navigator.of(context).pushNamed(ROUTER_LOGIN, arguments: fromOtherPage);
      //     },
      //   ),
      InkWell(
        child: Text("登录"),
        onTap: (){
          Log.i("toolbar", "click login button");
          var fromOtherPage = true;
          Navigator.of(context).pushNamed(ROUTER_LOGIN, arguments: fromOtherPage);
        },
      ),
      SizedBox(width: 16)
    ],
  );
}

Widget _buildLoginedWidget(BuildContext context){
  return InkWell(
    child: Text(Account.instance().accountDisplayName()),
    onTap: () async {
      Log.i("toolbar", "click logined button");
      await LoginManager.instance().clearLoginData();
    },
  );
}




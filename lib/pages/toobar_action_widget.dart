// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:geji_music_client/common/account.dart';
import 'package:geji_music_client/pages/routers.dart';
import 'package:geji_music_client/util/log.dart';

Widget BuildToolbarActionWidget(BuildContext context){
  final isLogined = Account.instance().isLogined();
  return Row(
    children: [
      isLogined?Text(Account.instance().accountDisplayName()):
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




// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:geji_music_client/data/servers.dart';
import 'package:geji_music_client/util/text_util.dart';

class AvatarWidget extends StatelessWidget{
  String? avatar;
  double size;
  Color color;

  AvatarWidget(this.avatar,{this.size = 60,this.color = Colors.blueGrey, super.key});
  
  @override
  Widget build(BuildContext context) {
    if(TextUtil.isEmpty(avatar)){
      return  Container(
        width: size + 4,
        height: size + 4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(size + 4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.5),
              spreadRadius: 0,      // 扩散半径
              blurRadius: 10,       // 模糊半径
              offset: Offset(0, 3), // 阴影偏移量 x,y
            ),
          ],
        ),
        child: Icon(
          Icons.person_rounded,
          size: size,
          color: color,
        ),
      );
    }

    return ClipOval(
      child: Image.network(
        JoinHttpUrl(avatar)??"",
        width: size,
        height: size,
        fit: BoxFit.cover,
      )
    );
  }
}
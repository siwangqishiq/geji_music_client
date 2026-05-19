// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:geji_music_client/data/servers.dart';
import 'package:geji_music_client/util/text_util.dart';

class AvatarWidget extends StatelessWidget{
  String? avatar;
  double size;

  AvatarWidget(this.avatar,{this.size = 60, super.key});
  
  @override
  Widget build(BuildContext context) {
    if(TextUtil.isEmpty(avatar)){
      return Icon(
        Icons.person_rounded,
        size: size,
        color: Colors.white,
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
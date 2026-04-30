
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geji_music_client/pages/home_page.dart';
import 'package:geji_music_client/pages/music_detail_page.dart';
import 'package:geji_music_client/pages/search_page.dart';
import 'package:geji_music_client/util/log.dart';

String ROUTER_HOME = "/";
String ROUTER_SEARCH = "/search";
String ROUTER_MUSIC_DETAIL = "/music_detail";

Map<String, WidgetBuilder> RounterMap(){
  return {
    ROUTER_HOME:(context) => const HomePage(),
    ROUTER_SEARCH:(context) => const SearchPage(),
    ROUTER_MUSIC_DETAIL:(context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      String mid = args?["mid"] ?? "";
      Log.i("Router","open music detail page mid: $mid");
      return MusicDetailPage(mid: mid);
    }
  };
}





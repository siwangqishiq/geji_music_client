
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geji_music_client/pages/home_page.dart';
import 'package:geji_music_client/pages/search_page.dart';

String ROUTER_HOME = "/";
String ROUTER_SEARCH = "/search";

Map<String, WidgetBuilder> RounterMap(){
  return {
    ROUTER_HOME:(context) => const HomePage(),
    ROUTER_SEARCH:(context) => const SearchPage()
  };
}





// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:geji_music_client/config.dart';

const String BASE_URL_TEST = "http://192.168.100.231:4488";
// const String BASE_URL_TEST = "http://192.168.31.177:4488";

const String BASE_URL = "http://124.220.0.185:4488";

String GetBaseUrl(){
  if(IsDebug){
    return BASE_URL_TEST;
  }
  return BASE_URL;
}


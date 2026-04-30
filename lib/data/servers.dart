// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:geji_music_client/config.dart';

// const String BASE_URL_TEST = "http://172.16.1.46:4488";
const String BASE_URL_TEST = "http://192.168.100.231:4488";

const String BASE_URL = "http://101.126.34.145:4488";

String GetBaseUrl(){
  if(IsDebug){
    return BASE_URL_TEST;
  }
  return BASE_URL;
}


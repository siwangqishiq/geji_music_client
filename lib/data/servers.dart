// ignore_for_file: non_constant_identifier_names, constant_identifier_names

import 'package:geji_music_client/config.dart';

// const String BASE_URL_TEST = "http://192.168.100.41:4488";
const String BASE_URL_TEST = "http://192.168.31.131:4488";

const String BASE_URL = "http://124.220.0.185:4488";

String GetBaseUrl(){
  if(IsDebug){
    return BASE_URL_TEST;
  }
  return BASE_URL;
}

String? JoinHttpUrl(String? origin){
  if(origin == null){
    return null;
  }

  if(origin.startsWith("http://") || origin.startsWith("https://")){
    return origin;
  }
  if(origin.startsWith("/")){
    return "${GetBaseUrl()}$origin";
  }
  return "${GetBaseUrl()}/$origin";
}


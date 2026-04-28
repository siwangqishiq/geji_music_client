

import 'package:flutter/material.dart';
import 'package:geji_music_client/config.dart';
import 'package:geji_music_client/pages/routers.dart';
import 'package:toastification/toastification.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child:MaterialApp(
        title: AppName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        routes: RounterMap(),
        initialRoute: ROUTER_SEARCH,
      ) 
    );
  }
}



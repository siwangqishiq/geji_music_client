

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geji_music_client/common/account.dart';
import 'package:geji_music_client/common/floatwin/floating_manager.dart';
import 'package:geji_music_client/config.dart';
import 'package:geji_music_client/pages/routers.dart';
import 'package:toastification/toastification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    FloatingManager.navigatorKey = navigatorKey;
    final bool isLogined = Account.instance().isLogined();
    return ToastificationWrapper(
      child:MaterialApp(
        title: AppName,
        scrollBehavior: AllScrollBehavior(),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
          // fontFamily: "cn"
        ),
        routes: RounterMap(),
        initialRoute: isLogined?ROUTER_HOME:ROUTER_SEARCH,
      ) 
    );
  }
}

class AllScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}



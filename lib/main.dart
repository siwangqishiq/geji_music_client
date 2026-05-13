import 'package:flutter/material.dart';
import 'package:geji_music_client/common/account.dart';
import 'package:geji_music_client/pages/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Account.instance().load();
  
  runApp(const MainApp());
}


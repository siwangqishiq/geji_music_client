import 'package:flutter/material.dart';
import 'package:geji_music_client/common/account.dart';
import 'package:geji_music_client/common/login_manager.dart';
import 'package:geji_music_client/pages/routers.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            const Text("HomePage"),
            Text(Account.instance().accountDisplayName()),
            InkWell(
              onTap: ()async{
                await LoginManager.instance().clearLoginData();
                if(!context.mounted){
                  return;
                }
                Navigator.of(context).pushNamed(ROUTER_LOGIN);
              },
              child: Text("退出"),
            )
          ],
        ),
      ),
    );
  }
}
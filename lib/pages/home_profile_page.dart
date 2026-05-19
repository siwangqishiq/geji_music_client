import 'package:flutter/material.dart';
import 'package:geji_music_client/common/account.dart';
import 'package:geji_music_client/common/widget/avatar.dart';
import 'package:geji_music_client/model/user.dart';
import 'package:geji_music_client/util/log.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  
  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _user = Account.instance().getUserInfo();
    Log.i("profile", "avatar :${_user?.avatar}");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 80),
          AvatarWidget(_user?.avatar,size: 120),
          Expanded(
            child: Container(color: Colors.transparent)
          ),

          SizedBox(height: 20)
        ],
      ),
    );
  }
}//end class
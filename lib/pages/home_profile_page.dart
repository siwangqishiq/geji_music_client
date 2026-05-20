import 'package:flutter/material.dart';
import 'package:geji_music_client/common/account.dart';
import 'package:geji_music_client/common/widget/avatar.dart';
import 'package:geji_music_client/common/widget/button.dart';
import 'package:geji_music_client/common/widget/dialog_helper.dart';
import 'package:geji_music_client/model/user.dart';
import 'package:geji_music_client/pages/routers.dart';
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
          AvatarWidget(_user?.avatar,size: 120,color: Colors.grey),
          SizedBox(height:16),
          Text(Account.instance().accountDisplayName(),style: TextStyle(fontSize: 32,color: Colors.black)),
          Expanded(
            child: Container(color: Colors.transparent)
          ),
          Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
            child: CommonButton(
              text: "退出登录",
              color: Colors.redAccent,
              onPressed: ()=> _loginOutClicked(context),
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }

  void _loginOutClicked(BuildContext context){
    Log.i("profile_page", "click logout button");
    DialogHelper.showAlertDialog("退出", "确认要退出当前账户吗?", context, 
      (){
        Log.i("profile_page", "click confirm loginout");
        _doLoginOut(context);
      }, 
      (){
        Log.i("profile_page", "click cancel button");
      });
  }

  void _doLoginOut(BuildContext context) async{
    Log.i("profile_page", "clear local login info");

    Log.i("profile_page", "clear local token");
    await Account.instance().saveToken(null);

    Log.i("profile_page", "clear local user info");
    await Account.instance().saveUser(null);

    if(!context.mounted){
      return;
    }
    Log.i("profile_page", "pop navi");
    Navigator.of(context).popAndPushNamed(ROUTER_LOGIN);
  }
}//end class
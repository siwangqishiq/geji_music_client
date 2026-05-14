import 'package:flutter/material.dart';
import 'package:geji_music_client/common/com_color.dart';
import 'package:geji_music_client/common/widget/button.dart';
import 'package:geji_music_client/common/widget/common_text_field.dart';
import 'package:geji_music_client/pages/routers.dart';
import 'package:geji_music_client/util/log.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 8,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("登录"),
      ),
      body: Container(
        color: ComColors.MainBackground,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 32),
              Image.asset("assets/images/app_icon.png",width: 100,height: 100),
              SizedBox(height: 24),
              CommonTextField(
                controller: _accountController,
                hintText: "请输入账号",
                prefixIcon: Icon(Icons.account_box,color: Colors.grey),
                onChanged: (String text) {
                },
              ),
              SizedBox(height: 16),
              CommonTextField(
                controller: _pwdController,
                obscureText: true,
                hintText: "请输入密码",
                prefixIcon: Icon(Icons.password,color: Colors.grey),
                onChanged: (String text) {
                },
              ),
              SizedBox(height: 16),
              CommonButton(
                text: "登录",
                onPressed: () {
                },
              ),
              const SizedBox(height: 24),
              InkWell(
                child: Text("注册新账号" , style: TextStyle(color: ComColors.MainSubColor),),
                onTap: () {
                  Log.i("toolbar", "click register button");
                  Navigator.of(context).pushNamed(ROUTER_REGISTER);
                },
              )
            ],
          ),
        )
      )
    );
  }
}
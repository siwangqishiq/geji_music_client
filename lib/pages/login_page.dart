import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geji_music_client/common/com_color.dart';
import 'package:geji_music_client/common/http_client.dart';
import 'package:geji_music_client/common/login_manager.dart';
import 'package:geji_music_client/common/widget/button.dart';
import 'package:geji_music_client/common/widget/common_text_field.dart';
import 'package:geji_music_client/common/widget/responsive_container.dart';
import 'package:geji_music_client/model/login.dart';
import 'package:geji_music_client/model/user.dart';
import 'package:geji_music_client/pages/routers.dart';
import 'package:geji_music_client/util/log.dart';
import 'package:geji_music_client/util/text_util.dart';
import 'package:geji_music_client/util/toast_util.dart';
import 'package:toastification/toastification.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  
  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 8,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("登录"),
        actions: [
          InkWell(
            onTap: (){
              Navigator.of(context).pushNamedAndRemoveUntil(
                ROUTER_SEARCH,
                (route) => false,
              );
            },
            child: Text("去听歌"),
          ),
        ]
      ),
      backgroundColor: ComColors.MainBackground,
      body: ResponsiveContainer(
        maxWidth: 500,
        child: SizedBox(
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
                  loading: _isLoading,
                  onPressed: () => _loginButtonClick()
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
        ),
      ) 
    );
  }

  void _loginButtonClick(){
    var account = _accountController.text;
    var password = _pwdController.text;

    Log.i("login", "login $account - $password");

    if(TextUtil.isEmpty(account) || TextUtil.isEmpty(password)) {
      ToastUtil.showAsError("用户或密码未填写");
      return;
    }

    _doLogin(account, password);
  }

  void _doLogin(String account, String password) async {
    setState(() {
      _isLoading = true;
    });

    try{
      Map<String ,dynamic> params = <String,dynamic>{
        "account":account,
        "password":password,
      };

      var resp = await HttpClient().post<LoginResp?>("/login",
        params: params,
        parser: (jsonMap) => LoginResp.fromMap(jsonMap),
      );

      Log.i("login", "resp ${resp.code}");
      if(resp.isSuccess()){
        var loginResp = resp.data;
        if(loginResp != null){
          Log.w("register", "Get login token : ${loginResp.token}");
          var userInfo = User.fromJson(json.encode(loginResp.encode()));
          Log.w("register", "Get login userinfo : ${json.encode(loginResp.encode())}");
          await LoginManager.instance().saveLoginData(loginResp.token, userInfo);
          ToastUtil.show("登录成功",style: ToastificationStyle.fillColored);

          if(!mounted){
            return;
          }

          Navigator.of(context).pushNamedAndRemoveUntil(
            ROUTER_HOME,
            (route) => false,
          );
        }
      }else{
        ToastUtil.showAsError(resp.msg??"登录错误");
      }
    }catch(e, stackTrace) {
      Log.e("register", "Error request $e");
      Log.e("register", "Error stackTrace $stackTrace");
      ToastUtil.showAsError("登录异常");
    }

    setState(() {
      _isLoading = false;
    });
  }
}//end class
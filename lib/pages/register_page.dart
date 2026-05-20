import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geji_music_client/common/http_client.dart';
import 'package:geji_music_client/common/widget/avatar.dart';
import 'package:geji_music_client/common/widget/button.dart';
import 'package:geji_music_client/common/widget/responsive_container.dart';
import 'package:geji_music_client/data/pkg.dart';
import 'package:geji_music_client/data/servers.dart';
import 'package:geji_music_client/model/upload.dart';
import 'package:geji_music_client/util/log.dart';
import 'package:geji_music_client/util/text_util.dart';
import 'package:geji_music_client/util/toast_util.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
   final ImagePicker _picker = ImagePicker();

  final TextEditingController _accountController =
      TextEditingController();

  final TextEditingController _nicknameController =
      TextEditingController();

  final TextEditingController _pwdController =
      TextEditingController();

  final TextEditingController _confirmPwdController =
      TextEditingController();
  
  String? _avatar;

  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text(
          "注册新用户",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),

      body: ResponsiveContainer(
        maxWidth: 500,
        child: Align(
          alignment: AlignmentGeometry.topCenter,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                /// 顶部Logo区域
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    color: Color(0xFF5B86E5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B86E5).withValues(alpha:0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      /// 头像
                      GestureDetector(
                        onTap: () => _pickImage(),
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha:0.15),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: AvatarWidget(_avatar),
                            ),

                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha:0.1),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                size: 18,
                                color: Color(0xFF5B86E5),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "创建你的新账号",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "可点击设置自定义头像",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha:0.85),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                /// 表单区域
                _buildInput(
                  controller: _accountController,
                  title: "账户",
                  hint: "请输入20位以内英文或数字",
                  icon: Icons.alternate_email_rounded,
                ),

                const SizedBox(height: 18),

                _buildInput(
                  controller: _nicknameController,
                  title: "用户昵称",
                  hint: "请输入昵称",
                  icon: Icons.badge_rounded,
                ),

                const SizedBox(height: 18),

                _buildInput(
                  controller: _pwdController,
                  title: "密码",
                  hint: "请输入密码",
                  icon: Icons.lock_outline_rounded,
                  obscureText: true,
                ),

                const SizedBox(height: 18),

                _buildInput(
                  controller: _confirmPwdController,
                  title: "确认密码",
                  hint: "请再次输入密码",
                  icon: Icons.lock_reset_rounded,
                  obscureText: true,
                ),

                const SizedBox(height: 34),

                /// 注册按钮
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color:Color(0xFF5B86E5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B86E5).withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: CommonButton(
                    text: "立即注册",
                    loading: _isRequesting,
                    onPressed: () => _clickSubmitButton()
                  )
                ),
              ],
            ),
          ),
        )
      )
    );
  }

  void _pickImage() async{
    Log.i("register", "pick image");

    try{
      var pickFile = await _picker.pickImage(source: ImageSource.gallery);
      if(pickFile == null){
        Log.i("register", "pick image no select");
        return;
      }
      Log.i("register", "pick file ${pickFile.mimeType} ${pickFile.path} ${pickFile.name} ${pickFile.length()}");
  
      Resp<UploadResp?> resp;
      if(kIsWeb){
        final bytes = await pickFile.readAsBytes();
        Log.i("register", "read file byte length ${bytes.length}");
        resp = await HttpClient().uploadFile("/uploadfile", fileBytes: bytes, fileName:pickFile.name);
      }else{
        resp = await HttpClient().uploadFile("/uploadfile", filePath:pickFile.path, fileName:pickFile.name);
      }
      if(resp.isSuccess()){
        var uploadResp = resp.data;
        Log.i("register", "上传成功 ${uploadResp?.url} ${uploadResp?.mime} ${uploadResp?.filesize}");
        _uploadAvatarSuccess(uploadResp?.url);
      }else{
        Log.e("register", "上传失败");
        ToastUtil.showAsError("上传失败");
      }
    }catch(e, stackTrace) {
      Log.e("register", "pick image error $e $stackTrace");
    }
  }

  void _uploadAvatarSuccess(String? url){
    if(TextUtil.isEmpty(url)){
      return;
    }

    setState(() {
      _avatar = url;
    });
  }

  void _clickSubmitButton(){
    Log.i("register", "click submit button");

    if(!_checkRegisterAccountInput()){
      Log.e("register", "input invalided");
      return;
    }

    _submitRegisterRequest();
  }

  void _submitRegisterRequest() async {
    setState(() {
      _isRequesting = true;
    });

    var account = _accountController.text;
    var nickname = _nicknameController.text;
    var pwd = _pwdController.text;

    Log.i("register", "input acount $account $nickname $pwd $_avatar");

    try{
      Map<String ,dynamic> params = <String,dynamic>{
        "account":account,
        "nickname":nickname,
        "password":pwd,
      };

      if(TextUtil.isNotEmpty(_avatar)){
        params["avatar"] = _avatar;
      }

      var resp = await HttpClient().post<String?>("/register",
        params: params,
      );

      Log.i("register", "resp ${resp.code}");
      if(resp.isSuccess()){
        ToastUtil.show("注册成功.",style: ToastificationStyle.fillColored);
        
        if(context.mounted){
          Navigator.of(context).pop();
        }
      }else{
        ToastUtil.showAsError(resp.msg??"注册错误");
      }
    }catch(e, stackTrace) {
      Log.e("register", "Error request $e");
      Log.e("register", "Error stackTrace $stackTrace");
      ToastUtil.showAsError("注册错误");
    }

    setState(() {
      _isRequesting = false;
    });
  }

  bool _checkRegisterAccountInput() {
    var account = _accountController.text.trim();
    var nickname = _nicknameController.text.trim();
    var pwd = _pwdController.text.trim();
    var rePwd = _confirmPwdController.text.trim();

    if (account.isEmpty){
      ToastUtil.showAsError("账号不能为空", algin: Alignment.topCenter);
      return false;
    }

    if (account.length > 32){
      ToastUtil.showAsError("账号过长，不能超过32个字符",algin: Alignment.topCenter);
      return false;
    }

    if(!TextUtil.isValidString(account)){
      ToastUtil.showAsError("账号中包含了非法字符",algin: Alignment.topCenter);
      return false;
    }

    if (nickname.isEmpty){
      ToastUtil.showAsError("昵称不能为空",algin: Alignment.topCenter);
      return false;
    }

    if (nickname.length > 64){
      ToastUtil.showAsError("昵称过长，不能超过64个字符",algin: Alignment.topCenter);
      return false;
    }

    if(pwd.isEmpty){
      ToastUtil.showAsError("未输入密码",algin: Alignment.topCenter);
      return false;
    }

    if(pwd.length > 32){
      ToastUtil.showAsError("密码不能超过32个字符",algin: Alignment.topCenter);
      return false;
    }

    if(!TextUtil.isValidString(pwd)){
      ToastUtil.showAsError("密码中包含了非法字符",algin: Alignment.topCenter);
      return false;
    }

    if(pwd != rePwd){
      ToastUtil.showAsError("两次密码输入不一致",algin: Alignment.topCenter);
      return false;
    }

    return true;
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String title,
    required String hint,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
              ),
              prefixIcon: Icon(
                icon,
                color: const Color(0xFF5B86E5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
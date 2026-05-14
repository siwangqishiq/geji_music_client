import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geji_music_client/common/http_client.dart';
import 'package:geji_music_client/data/pkg.dart';
import 'package:geji_music_client/data/servers.dart';
import 'package:geji_music_client/model/upload.dart';
import 'package:geji_music_client/util/log.dart';
import 'package:geji_music_client/util/text_util.dart';
import 'package:geji_music_client/util/toast_util.dart';
import 'package:image_picker/image_picker.dart';

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

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
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
                            child: _buildAvatarWidget(),
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
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {},
                    child: const Center(
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.app_registration_rounded,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "立即注册",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

  Widget _buildAvatarWidget(){
    if(TextUtil.isEmpty(_avatar)){
      return const Icon(
        Icons.person_rounded,
        size: 60,
        color: Colors.white,
      );
    }

    return ClipOval(
      child: Image.network(
        JoinHttpUrl(_avatar)??"",
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      )
    );
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
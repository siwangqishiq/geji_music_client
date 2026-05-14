import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 8,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: Text("注册新用户"),
      ),
      body: Center(
        child: const Text("RegisterPage"),
      ),
    );
  }
}
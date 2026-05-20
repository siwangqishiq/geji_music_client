import 'package:flutter/material.dart';

class FavorlistPage extends StatelessWidget {
  const FavorlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 8,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          title: Text("收藏歌单"),
        ),
        body: Center(
          child: Text("收藏歌单!!!"),
        ),
      )
    );
  }
}//end class
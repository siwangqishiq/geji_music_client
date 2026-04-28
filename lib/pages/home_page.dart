import 'package:flutter/material.dart';
import 'package:geji_music_client/config.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(AppName,style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),),
      ),
      body: Center(
        child: const Text("HomePage"),
      ),
    );
  }
}
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geji_music_client/common/floatwin/player_state.dart';

class FloatingPlayer extends StatefulWidget {
  const FloatingPlayer({super.key});

  @override
  State<FloatingPlayer> createState() => _FloatingPlayerState();
}

class _FloatingPlayerState extends State<FloatingPlayer> {
  Offset offset = const Offset(0, 500);
  double animationValue = 0;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            offset += details.delta;
          });
        },
        onPanEnd: (_) {
          _snapToEdge(screen);
        },
        onTap: () {
          // Navigator.of(context).pushNamed("/music_detail");
        },
        child: AnimatedBuilder(
          animation: FloatWinPlayerState.instance,
          builder: (context, _) {
            return Material(
              elevation: 10,
              shape: const CircleBorder(),
              child: Transform.rotate(
                angle: FloatWinPlayerState.instance.isPlaying ? animationValue : 0,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: FloatWinPlayerState.instance.coverUrl.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(
                              FloatWinPlayerState.instance.coverUrl,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                    color: Colors.blue,
                  ),
                  child: _buildInner(),
                ),
              )
            );
          },
        ),
      ),
    );
  }

  // Widget _buildFallbackCover(){
  //   return Container(
  //     width: 64,
  //     height: 64,
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           Colors.grey.shade300,
  //           Colors.grey.shade100,
  //         ],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //     ),
  //     child: Center(
  //       child: Icon(
  //         Icons.music_note,
  //         size: 48,
  //         color: Colors.grey.shade500,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildInner() {
    return Center(
      child: IconButton(
        icon: Icon(
          FloatWinPlayerState.instance.isPlaying
              ? Icons.pause
              : Icons.play_arrow,
          color: Colors.white,
        ),
        onPressed: () {
          FloatWinPlayerState.instance.toggle();
        },
      ),
    );
  }

  void _snapToEdge(Size screen) {
    double x = offset.dx;
    double y = offset.dy;

    // 限制边界
    x = max(0, min(x, screen.width - 64));
    y = max(0, min(y, screen.height - 64));

    // 吸附左右边
    if (x < screen.width / 2) {
      x = 0;
    } else {
      x = screen.width - 64;
    }

    setState(() {
      offset = Offset(x, y);
    });
  }
}


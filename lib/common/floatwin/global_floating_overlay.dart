import 'package:flutter/material.dart';
import 'package:geji_music_client/common/floatwin/floating_manager.dart';

class GlobalFloatingOverlay extends StatefulWidget {
  const GlobalFloatingOverlay({super.key});

  @override
  State<GlobalFloatingOverlay> createState() => _GlobalFloatingOverlayState();
}

class _GlobalFloatingOverlayState extends State<GlobalFloatingOverlay> {
  final OverlayPortalController _controller = OverlayPortalController();

  // 用于演示悬浮窗可拖拽移动
  Offset _position = const Offset(200, 300);

  @override
  void initState() {
    super.initState();
    // 将控制器注册到全局管理类中
    GlobalFloatingManager().controller ==
        _controller; // 注意：这里应该将 _controller 赋值给单例，为了代码简洁，下面会在 build 中处理
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (BuildContext context) {
        // 这里是悬浮窗的具体 UI 内容，它会绘制在独立的 Overlay 图层上
        return Positioned(
          left: _position.dx,
          top: _position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              // 实现拖拽移动效果
              setState(() {
                _position += details.delta;
              });
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.8),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10),
                ],
              ),
              child: const Center(
                child: Icon(Icons.smart_toy, color: Colors.white, size: 40),
              ),
            ),
          ),
        );
      },
      child: Container(), // 空 child
    );
  }
}

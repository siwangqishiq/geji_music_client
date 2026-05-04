import 'package:flutter/material.dart';

class GlobalFloatingManager {
  static final GlobalFloatingManager _instance =
      GlobalFloatingManager._internal();
  factory GlobalFloatingManager() => _instance;
  GlobalFloatingManager._internal();

  // 控制器，用于控制 OverlayPortal 的显示/隐藏
  final OverlayPortalController controller = OverlayPortalController();

  // 统一显示方法
  void show() => controller.show();

  // 统一隐藏方法
  void close() => controller.hide();

  // 切换显示/隐藏
  void toggle() => controller.toggle();
}

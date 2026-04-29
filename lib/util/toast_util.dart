import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastUtil {
  static void show(String content,{
    AlignmentGeometry? algin = Alignment.bottomCenter,
    Duration? autoCloseDuration = const Duration(seconds: 3)}) {
    toastification.show(
      title: Text(content),
      autoCloseDuration:autoCloseDuration,
      alignment:algin,
      style: ToastificationStyle.simple
    );
  }

  static void showAsError(String content,{
    AlignmentGeometry? algin = Alignment.bottomCenter,
    Duration? autoCloseDuration = const Duration(seconds: 3)}) {
    toastification.show(
      title: Text(content),
      autoCloseDuration:autoCloseDuration,
      alignment:algin,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored
    );
  }

}

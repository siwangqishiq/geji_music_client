import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  /// 按钮文字
  final String text;

  /// 点击事件
  final VoidCallback? onPressed;

  /// 是否可用
  final bool enabled;

  /// 是否加载中
  final bool loading;

  /// 高度
  final double height;

  /// 圆角
  final double borderRadius;

  /// 背景颜色
  final Color color;

  /// 禁用颜色
  final Color disabledColor;

  /// 文字颜色
  final Color textColor;

  /// 是否撑满宽度
  final bool expand;

  const CommonButton({
    super.key,
    required this.text,
    this.onPressed,
    this.enabled = true,
    this.loading = false,
    this.height = 52,
    this.borderRadius = 16,
    this.color = const Color(0xFF4A90E2),
    this.disabledColor = const Color(0xFFBFC9D9),
    this.textColor = Colors.white,
    this.expand = true,
  });

  bool get _clickable => enabled && !loading;

  @override
  Widget build(BuildContext context) {
    final Color bgColor = _clickable ? color : disabledColor;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: enabled ? 1 : 0.7,
      child: Container(
        width: expand ? double.infinity : null,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: bgColor,
          boxShadow: _clickable
              ? [
                  BoxShadow(
                    color: bgColor.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(borderRadius),
            onTap: _clickable ? onPressed : null,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: loading
                    ? SizedBox(
                        key: const ValueKey("loading"),
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(textColor),
                        ),
                      )
                    : Text(
                        text,
                        key: const ValueKey("text"),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
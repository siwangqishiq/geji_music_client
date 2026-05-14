
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  bool obscureText = false;
  Icon? prefixIcon;

  CommonTextField({
    super.key,
    required this.controller,
    this.hintText = "请输入",
    this.obscureText = false,
    this.prefixIcon,
    this.onChanged,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldTextFieldState();
}

class _CommonTextFieldTextFieldState extends State<CommonTextField> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
          letterSpacing: 1.2,
        ),
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          prefixIcon: widget.prefixIcon,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Colors.blueAccent,
              width: 2,
            ),
          ),
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}


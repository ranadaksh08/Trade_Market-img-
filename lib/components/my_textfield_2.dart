import 'package:flutter/material.dart';

class MyTextfield2 extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int minLines;
  final int maxLines;
  final IconData? icon;
  final TextInputType keyboardType;

  const MyTextfield2({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.minLines = 1,
    this.maxLines = 1,
    this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1C23),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFF2A2A2A),
          ),
        ),
        child: TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          cursorColor: const Color(0xFFC9A24D),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: const Color(0xFFC9A24D),
                  )
                : null,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.white54,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
          ),
        ),
      ),
    );
  }
}

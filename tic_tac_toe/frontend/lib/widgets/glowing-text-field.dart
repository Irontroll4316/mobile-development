import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/colors.dart';

class GlowingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color color;
  const GlowingTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: color, blurRadius: 20, spreadRadius: 3)],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: bgColor,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white,
            shadows: [Shadow(blurRadius: 20, color: color)],
          ),
        ),
        style: TextStyle(
          color: Colors.white,
          shadows: [Shadow(blurRadius: 20, color: color)],
        ),
      ),
    );
  }
}

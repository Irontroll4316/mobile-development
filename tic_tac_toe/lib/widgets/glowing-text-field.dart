import 'package:flutter/material.dart';
import 'package:tic_tac_toe/utils/colors.dart';

class GlowingTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const GlowingTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.blue, blurRadius: 20, spreadRadius: 3),
        ],
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
            shadows: [Shadow(blurRadius: 20, color: Colors.blue)],
          ),
        ),
      ),
    );
  }
}

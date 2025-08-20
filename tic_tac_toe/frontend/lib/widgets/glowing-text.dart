import 'package:flutter/material.dart';

class GlowingText extends StatelessWidget {
  final List<Shadow> shadows;
  final String text;
  final double fontSize;
  const GlowingText({
    super.key,
    required this.shadows,
    required this.text,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
        shadows: shadows,
      ),
      textAlign: TextAlign.center,
    );
  }
}

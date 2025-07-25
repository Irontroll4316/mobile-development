import 'package:flutter/material.dart';

Color strengthenColor(Color color, double factor) {
  int r = (color.r * factor).clamp(0, 255).toInt();
  int g = (color.g * factor).clamp(0, 255).toInt();
  int b = (color.b * factor).clamp(0, 255).toInt();
  return Color.fromARGB(color.a.round(), r, g, b);
}

List<DateTime> generateWeekDates(int weekOffset) {
  final today = DateTime.now();
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek = startOfWeek.add(Duration(days: weekOffset * 7));
  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

String rgbToHex(Color color) {
  return '${((color.r * 255).round() & 0xff).toString().padLeft(2, '0')}${((color.g * 255).round() & 0xff).toString().padLeft(2, '0')}${((color.b * 255).round() & 0xff).toString().padLeft(2, '0')}';
}

Color hexToRgb(String color) {
  return Color(int.parse(color, radix: 16) + 0xFF000000);
}

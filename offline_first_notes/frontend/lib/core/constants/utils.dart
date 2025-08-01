import 'package:flutter/material.dart';

List<DateTime> generateWeekDates(int weekOffset) {
  final today = DateTime.now();
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday));
  startOfWeek = startOfWeek.add(Duration(days: weekOffset * 7));
  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

String rgbToHex(Color color) {
  return '${((color.r * 255).round() & 0xff).toRadixString(16).padLeft(2, '0')}${((color.g * 255).round() & 0xff).toRadixString(16).padLeft(2, '0')}${((color.b * 255).round() & 0xff).toRadixString(16).padLeft(2, '0')}';
}

Color hexToRgb(String color) {
  return Color(int.parse(color, radix: 16) + 0xFF000000);
}

Color greyOut(Color color) {
  return Color.fromARGB(
    255,
    (((color.r * 255).round() & 0xff) * .3 + 90).round(),
    (((color.g * 255).round() & 0xff) * .3 + 90).round(),
    (((color.b * 255).round() & 0xff) * .3 + 90).round(),
  );
}

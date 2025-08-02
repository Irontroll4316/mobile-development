import 'package:flutter/material.dart';

class TemplateCard extends StatelessWidget {
  final Color color;
  final String name;
  final String selected;
  const TemplateCard({
    super.key,
    required this.color,
    required this.name,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: (selected == name)
          ? BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 2),
            )
          : BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

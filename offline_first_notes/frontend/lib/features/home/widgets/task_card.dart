import 'package:flutter/material.dart';
import 'package:offline_first_notes/core/constants/utils.dart';

class TaskCard extends StatelessWidget {
  final Color color;
  final String header;
  final String descriptionText;
  final int completed;
  const TaskCard({
    super.key,
    required this.color,
    required this.header,
    required this.descriptionText,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: (completed == 0) ? color : greyOut(color),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black, width: 2),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              decoration: (completed == 0)
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
          ),
          Text(
            descriptionText,
            style: TextStyle(
              fontSize: 14,
              decoration: (completed == 0)
                  ? TextDecoration.none
                  : TextDecoration.lineThrough,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

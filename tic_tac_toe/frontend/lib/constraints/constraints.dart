import 'package:flutter/material.dart';

class Constraints extends StatelessWidget {
  final Widget child;
  const Constraints({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: child,
      ),
    );
  }
}

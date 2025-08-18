import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constraints/constraints.dart';
import 'package:tic_tac_toe/pages/create_room.dart';
import 'package:tic_tac_toe/pages/join_room.dart';
import 'package:tic_tac_toe/widgets/glowing-button.dart';
import 'package:tic_tac_toe/widgets/glowing-text.dart';

class MainMenu extends StatelessWidget {
  static route() => MaterialPageRoute(builder: (context) => const MainMenu());
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Constraints(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GlowingText(
              shadows: [Shadow(blurRadius: 50, color: Colors.blue)],
              text: "Welcome To Tic-Tac-Toe",
              fontSize: 68,
            ),
            const SizedBox(height: 100),
            GlowingButton(
              onTap: () {
                Navigator.of(context).push(CreateRoom.route());
              },
              text: "Create Room",
            ),
            const SizedBox(height: 50),
            GlowingButton(
              onTap: () {
                Navigator.of(context).push(JoinRoom.route());
              },
              text: "Join Room",
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

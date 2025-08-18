import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constraints/constraints.dart';
import 'package:tic_tac_toe/widgets/glowing-button.dart';
import 'package:tic_tac_toe/widgets/glowing-text-field.dart';
import 'package:tic_tac_toe/widgets/glowing-text.dart';

class JoinRoom extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const JoinRoom());

  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _gameIdController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _gameIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Constraints(
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const GlowingText(
                shadows: [Shadow(blurRadius: 50, color: Colors.blue)],
                text: "Join Room",
                fontSize: 60,
              ),
              SizedBox(height: size.height * 0.08),
              GlowingTextField(
                controller: _nameController,
                hintText: "Enter Your Nickname",
              ),
              const SizedBox(height: 25),
              GlowingTextField(
                controller: _gameIdController,
                hintText: "Enter Your Game ID",
              ),
              SizedBox(height: size.height * 0.05),
              GlowingButton(onTap: () {}, text: "Join!"),
            ],
          ),
        ),
      ),
    );
  }
}

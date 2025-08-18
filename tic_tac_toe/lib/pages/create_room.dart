import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constraints/constraints.dart';
import 'package:tic_tac_toe/widgets/glowing-button.dart';
import 'package:tic_tac_toe/widgets/glowing-text-field.dart';
import 'package:tic_tac_toe/widgets/glowing-text.dart';

class CreateRoom extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const CreateRoom());
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
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
                text: "Create Room",
                fontSize: 60,
              ),
              SizedBox(height: size.height * 0.08),
              GlowingTextField(
                controller: _nameController,
                hintText: "Enter Your Nickname",
              ),
              SizedBox(height: size.height * 0.05),
              GlowingButton(onTap: () {}, text: "Create!"),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class Settings extends ConsumerStatefulWidget {
  const Settings({super.key});

  @override
  ConsumerState<Settings> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<Settings> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext contextf) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(children: [
        GestureDetector(
          onTap: () async {
            final ImagePicker picker = ImagePicker();
            final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery, requestFullMetadata: false, );

            if (pickedImage != null) {
              ref.read(userProvider.notifier).updateImage(File(pickedImage.path));
            }
          },
          child: Padding(
            padding: EdgeInsetsGeometry.only(top: 20),
            child: CircleAvatar(
              radius: 100,
              foregroundImage: NetworkImage(currentUser.user.profilePicture),
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(child: Text("Tap Image to Change", style: TextStyle(fontSize: 11))),
        TextFormField(
          decoration: InputDecoration(labelText: "Enter Your Name"),
          controller: _nameController,
        ),
        SizedBox(height: 20),
        Container(
          width: 150,
          decoration: BoxDecoration(color: Color(0xffB5A440), borderRadius: BorderRadius.circular(30)),
          child: TextButton(onPressed: () {
            ref.read(userProvider.notifier).updateName(_nameController.text);
            _nameController.text = "";
          },
          child: Text("Update", style: TextStyle(color: Colors.white, fontSize: 18))),
        )
      ],)
    );
  }
}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/setting.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () =>Scaffold.of(context).openDrawer(),
              child: Padding(
                padding: EdgeInsetsGeometry.all(8),
                child: CircleAvatar(
                    backgroundImage: NetworkImage(currentUser.user.profilePicture)
                  ),
              ),
            );
          }
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        title: Text("Home", style: TextStyle(color: Colors.white)),
      ),
      body: Column(children: [
        (currentUser.user.email != 'error') ? Text(currentUser.user.email) : const Text(''),
        (currentUser.user.name != 'error') ? Text(currentUser.user.name, style: TextStyle(color: Colors.black)) : const Text(''),
      ]),
      drawer: Drawer(
        child: Column(
          children: [
            Image.network(
              currentUser.user.profilePicture
            ),
            ListTile(
              title: Text(
                "Hello, ${currentUser.user.name}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),  
              ),
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Settings()));
              }
            ),
            
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.red[900],),
                    title: Text("Sign Out", style: TextStyle(color: Colors.red[900])),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      ref.read(userProvider.notifier).clearUserState();
                    }
                  ),
                ),
              ),
            ),
        ],
      )),
    );
  }
}
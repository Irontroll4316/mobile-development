import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/pages/home.dart';
import 'package:twitter_clone/pages/signin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:twitter_clone/providers/user_provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Twitter Clone',
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            ref.read(userProvider.notifier).getUserInfo(snapshot.data!.email!);
            return const Home();
          }
          return const SignIn();
        }
      ),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          shadowColor: Colors.transparent,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
          centerTitle: true,
        )
      )
    );
  }
}
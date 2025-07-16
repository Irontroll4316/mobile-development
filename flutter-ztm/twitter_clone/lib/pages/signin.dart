import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:twitter_clone/pages/signup.dart';
import 'package:twitter_clone/providers/user_provider.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=>^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-z]+");
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _signInKey,
        child: Container(
          color: Colors.indigo,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FaIcon(
                FontAwesomeIcons.twitter,
                color: Colors.white,
                size: 90,
              ),
              SizedBox(height: 50),
              Text(
                "Log in to Twitter", 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 30, 15, 0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, 
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15, 
                      horizontal: 20
                    ),
                  ),
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator:  (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter an email!";
                    } else if (!emailValid.hasMatch(value)) {
                      return "Please enter a valid email!";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(15, 30, 15, 30),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200, 
                  borderRadius: BorderRadius.circular(20)
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: "Password",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    )
                  ),
                  controller: _passwordController,
                  obscureText: true,
                  validator:(value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password!";
                    } else if (value.length < 8) {
                      return "Password must be at least 8 characters!";
                    }
                    return null;
                  },
                ),
              ),
              Container(
                width: 150,
                decoration: BoxDecoration(
                  color: Color(0xffB5A440),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: TextButton(
                  onPressed: () async {
                    if (_signInKey.currentState!.validate()) {
                      try {
                        await _auth.signInWithEmailAndPassword(
                          email: _emailController.text, 
                          password: _passwordController.text
                        );
                        ref.read(userProvider.notifier).getUserInfo(_emailController.text);
                      } catch (e) {
                        if(!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignUp()));
                },
                child: const Text(
                  "Don't have an account? Sign up here!",
                  style: TextStyle(
                    color: Colors.white,
                  )
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
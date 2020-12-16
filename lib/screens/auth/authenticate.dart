import 'package:flutter/material.dart';
import 'package:todoey/screens/auth/register.dart';
import 'package:todoey/screens/auth/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleScreen() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: showSignIn
          ? SignIn(toggleScreen: toggleScreen)
          : RegisterScreen(
              toggleScreen: toggleScreen,
            ),
    );
  }
}

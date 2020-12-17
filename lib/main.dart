import 'package:flutter/material.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/screens/todo/add_todo_screen.dart';
import 'package:todoey/screens/wrapper.dart';

import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:todoey/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserModel>.value(
            value: AuthService().user,
            child: MaterialApp(
              theme: ThemeData(
                fontFamily: 'Roboto',
                inputDecorationTheme: InputDecorationTheme(
                  filled: true,
                  fillColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              home: Wrapper(),
            ),
          );
        }
        return CircularProgressIndicator(
          strokeWidth: 10.0,
          backgroundColor: Colors.black,
        );
      },
    );
  }
}

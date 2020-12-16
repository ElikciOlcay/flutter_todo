import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/screens/auth/authenticate.dart';
import 'package:todoey/screens/todo/todo_screen.dart';
import 'package:todoey/services/database.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    return user == null
        ? Authenticate()
        : StreamProvider.value(
            value: DatabaseService(uid: user.userId).todos,
            child: TodoScreen(),
          );
  }
}

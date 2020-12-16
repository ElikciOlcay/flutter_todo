import 'package:flutter/material.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/services/database.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String title;
  final String uid;
  final Function checkboxCallback;
  final Function deleteTaskCallback;

  TaskTile(
      {this.isChecked,
      this.title,
      this.checkboxCallback,
      this.deleteTaskCallback,
      this.uid});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    DatabaseService _db = DatabaseService(uid: user.userId);

    return ListTile(
        title: Text(
          title,
          style: TextStyle(
              fontSize: 22.0,
              decoration: isChecked ? TextDecoration.lineThrough : null),
        ),
        trailing: Checkbox(
          value: isChecked,
          activeColor: Colors.lightBlueAccent,
          onChanged: (bool newValue) => _db.updateTodo(uid, newValue),
        ),
        onLongPress: () async => await _db.deleteTodo(uid));
  }
}

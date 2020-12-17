import 'package:flutter/material.dart';

import 'package:todoey/models/user.dart';

import 'package:todoey/services/database.dart';
import 'package:provider/provider.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String title;
  final String uid;
  final String imgUrl;
  final DateTime todoDate;
  final Function showBottomSheetCallback;

  TaskTile(
      {this.isChecked,
      this.title,
      this.uid,
      this.imgUrl,
      this.todoDate,
      this.showBottomSheetCallback});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    DatabaseService _db = DatabaseService(uid: user.userId);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 20.0,
                decoration: isChecked ? TextDecoration.lineThrough : null),
          ),
        ),
        trailing: Checkbox(
          value: isChecked,
          activeColor: Colors.lightBlueAccent,
          onChanged: (bool newValue) => _db.updateTodoIsDone(uid, newValue),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  todoDate == null
                      ? SizedBox()
                      : Icon(Icons.calendar_today,
                          size: 15.0, color: Colors.teal)
                ],
              ),
              imgUrl == null
                  ? SizedBox()
                  : Icon(Icons.image_outlined, size: 16.0, color: Colors.teal)
            ],
          ),
        ),
        onLongPress: () async => await _db.deleteTodo(uid),
        onTap: showBottomSheetCallback,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:todoey/models/task.dart';
import 'task_tile.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _listKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<List<Todo>>(context);

    return todos != null
        ? ListView.builder(
            key: _listKey,
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return TaskTile(
                title: todos[index].title,
                isChecked: todos[index].isDone,
                uid: todos[index].uid,
              );
            },
          )
        : Text('..loading');
  }
}

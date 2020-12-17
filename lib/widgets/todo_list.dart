import 'package:flutter/material.dart';
import 'package:todoey/models/todo.dart';
import 'package:todoey/screens/todo/add_todo_screen.dart';
import 'package:todoey/widgets/modalBottomSheet.dart';
import 'todo_tile.dart';
import 'package:provider/provider.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final _listKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<List<Todo>>(context);

    void showAddTodoPanel(Todo todo) {
      ModalBottomSheet(context: context, sheetWidget: AddTodoScreen(todo))
          .showSheet();
    }

    return todos != null
        ? ListView.builder(
            key: _listKey,
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return TaskTile(
                title: todos[index].title,
                isChecked: todos[index].isDone,
                uid: todos[index].uid,
                imgUrl: todos[index].imgUrl,
                todoDate: todos[index].toDate,
                showBottomSheetCallback: () => showAddTodoPanel(todos[index]),
              );
            },
          )
        : Text('..loading');
  }
}

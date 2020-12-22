import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todoey/models/todo.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/screens/todo/add_todo_screen.dart';
import 'package:todoey/services/database.dart';
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
    final user = Provider.of<UserModel>(context);
    DatabaseService _db = DatabaseService(uid: user.userId);

    void showAddTodoPanel({Todo todo}) {
      ModalBottomSheet(context: context, sheetWidget: AddTodoScreen(todo))
          .showSheet();
    }

    return todos != null
        ? ListView.builder(
            key: _listKey,
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                key: UniqueKey(),
                background: Container(
                  color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: FaIcon(
                          FontAwesomeIcons.trash,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                onDismissed: (direction) async {
                  _db.deleteTodo(todos[index].uid);
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.teal,
                      duration: Duration(milliseconds: 700),
                      elevation: 0.0,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                      content: Text('Todo deleted'),
                    ),
                  );
                },
                child: TaskTile(
                  title: todos[index].title,
                  isChecked: todos[index].isDone,
                  uid: todos[index].uid,
                  imgUrl: todos[index].imgUrl,
                  todoDate: todos[index].toDate,
                  showBottomSheetCallback: () =>
                      showAddTodoPanel(todo: todos[index]),
                ),
              );
            },
          )
        : Text('..loading');
  }
}

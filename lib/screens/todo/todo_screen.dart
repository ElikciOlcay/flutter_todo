import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todoey/models/category.dart';
import 'package:todoey/models/todo.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/screens/todo/add_category_screen.dart';
import 'package:todoey/services/auth.dart';
import 'package:todoey/services/database.dart';
import 'package:todoey/widgets/category_widget.dart';
import 'package:todoey/widgets/modalBottomSheet.dart';
import 'package:todoey/widgets/todo_list.dart';
import 'package:todoey/screens/todo/add_todo_screen.dart';
import 'package:provider/provider.dart';

class TodoScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final todos = Provider.of<List<Todo>>(context);
    final categories = Provider.of<List<Category>>(context);

    void _showAddTodoPanel() {
      ModalBottomSheet(context: context, sheetWidget: AddTodoScreen())
          .showSheet();
    }

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTodoPanel();
        },
        backgroundColor: Colors.lightBlueAccent,
        child: Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 60.0, bottom: 30.0, left: 30.0, right: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Todoey',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 50.0,
                        fontFamily: 'Pacifico',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () async => _auth.signOut(),
                      child: Icon(
                        Icons.logout,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
                Text(
                  "Todo's ${todos != null ? todos.length : ''}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
          //CategoryWidget(categories: categories),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                ),
              ),
              child: todos != null && todos.length > 0
                  ? TodoList()
                  : ListView(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image(
                            image: AssetImage('images/meditation.jpg'),
                          ),
                          Text(
                            'Du bist fertig für Heute',
                            style: TextStyle(
                              fontSize: 22.0,
                            ),
                          )
                        ],
                      ),
                    ]),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/todo.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/services/database.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todoey/widgets/image_container.dart';
import 'package:todoey/screens/camera/camera_screen.dart';
import 'package:todoey/shared/date_formatter.dart';

class AddTodoScreen extends StatefulWidget {
  final Todo todo;

  AddTodoScreen([this.todo]);

  @override
  _AddTodoScreenState createState() => todo == null
      ? _AddTodoScreenState()
      : _AddTodoScreenState.todo(
          title: todo.title,
          dateString: DateFormatter(date: todo.toDate).formattedDate,
          date: todo.toDate,
          firebaseImagePath: todo.imgUrl,
          location: todo.location,
          todoId: todo.uid);
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  _AddTodoScreenState();

  _AddTodoScreenState.todo(
      {String title,
      String dateString,
      DateTime date,
      String firebaseImagePath,
      String location,
      String todoId}) {
    this.newTaskTitle = title;
    this.editTodo = true;
    this.firebaseImagePath = firebaseImagePath;
    this.selectedDateString = dateString;
    this.selectedDate = date;
    this.userLocation = location;
    this.todoId = todoId;
  }

  String newTaskTitle;
  DateTime selectedDate;
  String selectedDateString = '';
  String hours;
  String imgPath;
  String firebaseImagePath;
  String userLocation;
  String todoId;
  bool editTodo = false;

  @override
  void initState() {
    super.initState();
  }

  void _cameraCallBack({String path, String location}) {
    setState(() {
      imgPath = path;
      userLocation = location;
      firebaseImagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    DatabaseService _db = DatabaseService(uid: user.userId);

    void createTodo() async {
      await _db
          .createTodo(title: newTaskTitle, toDate: selectedDate)
          .then((todoId) => {
                _db.uploadImage(filePath: imgPath, fileName: todoId).then(
                    (imgUrl) async =>
                        await _db.addImageToTodo(todoId, imgUrl, userLocation))
              });
    }

    void updateTodo() async {
      await _db
          .updateTodo(title: newTaskTitle, toDate: selectedDate, todoId: todoId)
          .then((value) => _db.uploadImage(filePath: imgPath, fileName: todoId))
          .then((imgUrl) async =>
              await _db.addImageToTodo(todoId, imgUrl, userLocation));
    }

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: TextEditingController()..text = newTaskTitle,
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'z.B. Treffen mit Alex heute um 11',
                hintStyle: TextStyle(
                  color: Colors.black26,
                ),
              ),
              autofocus: true,
              style: TextStyle(fontSize: 20.0),
              onChanged: (value) {
                newTaskTitle = value;
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    DatePicker.showDateTimePicker(
                      context,
                      currentTime: DateTime.now(),
                      locale: LocaleType.de,
                      showTitleActions: true,
                      onConfirm: (date) {
                        setState(() {
                          selectedDate = date;
                          selectedDateString =
                              DateFormatter(date: date).formattedDate;
                        });
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.0, right: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    height: 40.0,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.date_range,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: selectedDateString.isEmpty ? 0.0 : 20.0,
                          ),
                          Text(
                            selectedDateString.isEmpty
                                ? ''
                                : selectedDateString,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraScreen(
                          cameraCallback: _cameraCallBack,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    height: 40.0,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.add_a_photo,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ImageContainer(
              imgPath: imgPath,
              firebaseImagePath: firebaseImagePath,
              userLocation: userLocation,
            ),
            MaterialButton(
              elevation: 0.0,
              height: 50.0,
              onPressed: () async {
                if (newTaskTitle != null) {
                  if (editTodo) {
                    updateTodo();
                  } else {
                    createTodo();
                  }
                  Navigator.pop(context);
                }
              },
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30.0,
              ),
              color: Colors.lightBlueAccent,
            )
          ],
        ),
      ),
    );
  }
}

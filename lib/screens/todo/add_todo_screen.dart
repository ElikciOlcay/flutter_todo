import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/services/database.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:io';
import 'package:todoey/screens/camera/camera_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:todoey/widgets/chip.dart';

class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  String newTaskTitle;
  DateTime selectedDate;
  String selectedDateString = '';
  String hours;
  String imgPath;
  String userLocation;

  void _cameraCallBack({String path, String location}) {
    setState(() {
      imgPath = path;
      userLocation = location;
    });
  }

  String _dateFormatter(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString();
    String day = date.day.toString();
    String hours = date.hour.toString();
    String minutes = date.minute.toString();
    String formattedDate = '$year-$month-$day / $hours:$minutes';
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    DatabaseService _db = DatabaseService(uid: user.userId);
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
                          selectedDateString = _dateFormatter(date);
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
            Container(
              alignment: Alignment.topLeft,
              margin: EdgeInsets.symmetric(vertical: 20.0),
              child: imgPath != null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            File(imgPath),
                            height: 100.0,
                            width: 50.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Container(
                          width: 200.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ToolChip(
                                icon: Icon(
                                  Icons.date_range,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                                label: _dateFormatter(
                                  DateTime.now(),
                                ),
                              ),
                              ToolChip(
                                icon: Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                                label: userLocation,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : SizedBox(),
            ),
            MaterialButton(
              elevation: 0.0,
              height: 50.0,
              onPressed: () async {
                if (newTaskTitle != null) {
                  await _db.createTodo(newTaskTitle, selectedDate).then(
                        (todoId) => {
                          _db
                              .uploadImage(filePath: imgPath, fileName: todoId)
                              .then((imgUrl) async => await _db.addImageToTodo(
                                  todoId, imgUrl, userLocation)),
                        },
                      );
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

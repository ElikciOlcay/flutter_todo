import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/services/database.dart';

class AddCategoryScreen extends StatelessWidget {
  String newCategoryTitle;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final DatabaseService _db = DatabaseService(uid: user.userId);

    void createCategory() async {
      await _db.createCategory(title: newCategoryTitle);
    }

    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                FlatButton(
                  onPressed: () => print('click'),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red, fontSize: 18.0),
                  ),
                ),
                Text(
                  'New category',
                  style: TextStyle(fontSize: 20.0),
                ),
                FlatButton(
                  onPressed: () {
                    if (newCategoryTitle != null) {
                      createCategory();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.black54, fontSize: 18.0),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1.0,
            ),
            TextField(
              autofocus: true,
              style: TextStyle(fontSize: 20.0),
              onChanged: (value) {
                newCategoryTitle = value;
              },
              decoration: InputDecoration(
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'z.B. Treffen mit Alex heute um 11',
                hintStyle: TextStyle(
                  color: Colors.black26,
                ),
              ),
            ),
            SizedBox(
              height: 80.0,
            )
          ],
        ),
      ),
    );
  }
}

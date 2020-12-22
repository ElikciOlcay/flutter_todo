import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todoey/models/category.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/screens/todo/add_category_screen.dart';
import 'package:todoey/services/database.dart';
import 'package:todoey/widgets/modalBottomSheet.dart';

class CategoryWidget extends StatelessWidget {
  CategoryWidget({this.categories});

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    final DatabaseService _db = DatabaseService(uid: user.userId);

    void deleteCategory({String id, String title}) async {
      await _db.deleteCategory(id);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.teal,
          duration: Duration(milliseconds: 1000),
          elevation: 0.0,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          content: RichText(
            text: TextSpan(
              children: [
                TextSpan(text: 'Category'),
                TextSpan(
                  text: ' $title',
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' deleted')
              ],
            ),
          ),
        ),
      );
    }

    void _showAddCategoryPanel() {
      ModalBottomSheet(context: context, sheetWidget: AddCategoryScreen())
          .showSheet();
    }

    GlobalKey<FormState> _listKey;
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          width: 80.0,
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: OutlineButton(
              borderSide:
                  BorderSide(color: Colors.white70, style: BorderStyle.solid),
              padding: EdgeInsets.symmetric(vertical: 10.0),
              onPressed: _showAddCategoryPanel,
              child: FaIcon(
                FontAwesomeIcons.plus,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 50.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: categories != null
                ? ListView.builder(
                    key: _listKey,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () {
                          deleteCategory(
                              id: categories[index].uid,
                              title: categories[index].title);
                          print(categories[index].title);
                        },
                        child: Card(
                          elevation: 0.0,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Center(
                                child: Text(
                              categories[index].title,
                              style: TextStyle(color: Colors.black45),
                            )),
                          ),
                        ),
                      );
                    },
                  )
                : SizedBox(),
          ),
        ),
      ],
    );
  }
}

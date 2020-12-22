import 'package:todoey/models/location.dart';

class Todo {
  final String title;
  final bool isDone;
  final String uid;
  final String imgUrl;
  final DateTime toDate;
  final Location location;

  Todo(
      {this.title,
      this.isDone = false,
      this.uid,
      this.imgUrl,
      this.toDate,
      this.location});
}

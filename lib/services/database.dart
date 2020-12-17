import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:path_provider/path_provider.dart';
import 'package:todoey/models/todo.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference _userCollection =
      FirebaseFirestore.instance.collection('user');

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future createUserWithTodo(String email) async {
    try {
      await _userCollection.doc(uid).set({'email': email});
      await _userCollection
          .doc(uid)
          .collection('todos')
          .doc()
          .set({'title': 'First Todo', 'isDone': false});
    } catch (e) {
      print(e);
      return null;
    }
  }

  List<Todo> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Todo(
        title: doc.data()['title'] ?? '',
        isDone: doc.data()['isDone'] ?? false,
        uid: doc.id,
        imgUrl: doc.data()['imgUrl'] ?? null,
        toDate: doc.data()['to'] == null ? null : doc.data()['to'].toDate(),
        location: doc.data()['location'] ?? null,
      );
    }).toList();
  }

  Stream<List<Todo>> get todos {
    return _userCollection
        .doc(uid)
        .collection('todos')
        .orderBy('to')
        .snapshots()
        .map(_taskListFromSnapshot);
  }

  Future updateTodoIsDone(todoId, isDone) {
    try {
      return _userCollection
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({'isDone': isDone});
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future createTodo({String title, DateTime toDate}) async {
    try {
      DocumentReference result =
          await _userCollection.doc(uid).collection('todos').add(
        {
          'title': title,
          'isDone': false,
          'to': toDate,
        },
      );
      return result.id;
    } catch (e) {
      print(e);
    }
  }

  Future updateTodo({todoId, isDone, title, toDate, image}) {
    try {
      return _userCollection
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({'isDone': isDone, 'title': title, 'to': toDate});
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future addImageToTodo(
      String todoId, String imgUrl, String userLocation) async {
    try {
      return _userCollection
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .update({'imgUrl': imgUrl, 'location': userLocation});
    } catch (e) {
      print(e);
    }
  }

  Future deleteTodo(String id) async {
    try {
      await _userCollection.doc(uid).collection('todos').doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  Future uploadImage({String filePath, String fileName}) async {
    if (filePath != null) {
      File file = File(filePath);

      try {
        firebase_storage.TaskSnapshot result = await firebase_storage
            .FirebaseStorage.instance
            .ref(fileName)
            .putFile(file);
        return result.ref.getDownloadURL();
      } on firebase_core.FirebaseException catch (e) {
        print(e.message);
      }
    }
  }
}

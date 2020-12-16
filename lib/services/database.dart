import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:path_provider/path_provider.dart';
import 'package:todoey/models/task.dart';

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
          uid: doc.id);
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

  Future updateTodo(todoId, isDone) {
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

  Future addImageToTodo(
      String todoId, String imgUrl, String userLocation) async {
    try {
      return _userCollection
          .doc(uid)
          .collection('todos')
          .doc(todoId)
          .collection('image')
          .doc()
          .set({'imgUrl': imgUrl, 'location': userLocation});
    } catch (e) {
      print(e);
    }
  }

  Future createTodo(String title, DateTime to) async {
    try {
      DocumentReference result =
          await _userCollection.doc(uid).collection('todos').add(
        {
          'title': title,
          'isDone': false,
          'to': to,
        },
      );
      return result.id;
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

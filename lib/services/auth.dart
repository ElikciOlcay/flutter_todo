import 'package:firebase_auth/firebase_auth.dart';
import 'package:todoey/models/user.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static String errorMessage;

  UserModel _userFromFirebase(User firebaseUser) {
    return firebaseUser != null
        ? UserModel(userId: firebaseUser.uid, email: firebaseUser.email)
        : null;
  }

  String get getErrorMessage {
    return errorMessage;
  }

  // auth change user stream
  Stream<UserModel> get user {
    return _auth
        .authStateChanges()
        //.map((User firebaseUser) => _userFromFirebase(firebaseUser));
        .map(_userFromFirebase);
  }

  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User firebaseUser = userCredential.user;
      return _userFromFirebase(firebaseUser);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser = userCredential.user;
      await DatabaseService(uid: firebaseUser.uid)
          .createUserWithTodo(firebaseUser.email);
      return _userFromFirebase(firebaseUser);
    } catch (e) {
      errorMessage = e.message;
      return null;
    }
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User firebaseUser = userCredential.user;
      return _userFromFirebase(firebaseUser);
    } catch (e) {
      errorMessage = e.message;
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}

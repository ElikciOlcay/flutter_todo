import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todoey/models/user.dart';
import 'database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String errorMessage;

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

  Future signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User firebaseUser = userCredential.user;

      if (user != null) {
        assert(!firebaseUser.isAnonymous);
        assert(await firebaseUser.getIdToken() != null);

        final User currentUser = _auth.currentUser;
        assert(firebaseUser.uid == currentUser.uid);

        await DatabaseService(uid: currentUser.uid)
            .createUserWithTodo(currentUser.email);

        return _userFromFirebase(currentUser);
      }
    }
    errorMessage = '';
    return null;
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}

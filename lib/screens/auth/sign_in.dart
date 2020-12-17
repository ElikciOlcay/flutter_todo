import 'package:flutter/material.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/widgets/loading.dart';
import 'package:todoey/services/auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todoey/widgets/socialmedia_button.dart';

class SignIn extends StatefulWidget {
  final Function toggleScreen;

  SignIn({this.toggleScreen});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  bool loading = false;
  String errorMessage = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void signInWithGoogle() async {
    setState(() {
      loading = true;
    });
    UserModel user = await _auth.signInWithGoogle();
    if (user == null) {
      setState(() {
        errorMessage = _auth.getErrorMessage;
        loading = false;
      });
    }
  }

  void signInWithEmailAndPassword() async {
    setState(() {
      loading = true;
    });
    UserModel user = await _auth.signInWithEmailAndPassword(
        emailController.text, passwordController.text);

    if (user == null) {
      setState(() {
        errorMessage = _auth.getErrorMessage;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingSpinner()
        : Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TyperAnimatedTextKit(
                        speed: Duration(milliseconds: 100),
                        repeatForever: false,
                        totalRepeatCount: 1,
                        text: [
                          'Todoey',
                        ],
                        textStyle: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 60.0,
                          fontFamily: 'Pacifico',
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Image(
                        image: AssetImage('images/clip-chatting.png'),
                        width: 250.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Form(
                          key: _formKey,
                          child: Column(children: [
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'Email',
                              ),
                              autocorrect: false,
                              controller: emailController,
                              onChanged: (value) {},
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Password',
                              ),
                              obscureText: true,
                              controller: passwordController,
                              onChanged: (value) {},
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width,
                              height: 50.0,
                              child: RaisedButton(
                                  color: Colors.lightBlueAccent,
                                  elevation: 0.0,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0),
                                  ),
                                  onPressed: signInWithEmailAndPassword),
                            ),
                            Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SocialMediaButton(
                                  icon: FaIcon(
                                    FontAwesomeIcons.facebook,
                                    size: 25.0,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                SocialMediaButton(
                                  icon: FaIcon(FontAwesomeIcons.google,
                                      size: 25.0, color: Colors.redAccent),
                                  onPressedCallback: signInWithGoogle,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                FlatButton(
                                    onPressed: () => widget.toggleScreen(),
                                    child: Text(
                                      'Sing up',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ))
                              ],
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}

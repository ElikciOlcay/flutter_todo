import 'package:flutter/material.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/widgets/loading.dart';
import 'package:todoey/services/auth.dart';

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

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingSpinner()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Text(
                'Sign in to Todo',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
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
                        RaisedButton(
                          color: Colors.pink,
                          child: Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            UserModel user =
                                await _auth.signInWithEmailAndPassword(
                                    emailController.text,
                                    passwordController.text);

                            if (user == null) {
                              setState(() {
                                errorMessage = _auth.getErrorMessage;
                                loading = false;
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Text('or'),
                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton(
                          color: Colors.pink,
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () => widget.toggleScreen(),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

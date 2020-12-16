import 'package:flutter/material.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/widgets/loading.dart';
import 'package:todoey/services/auth.dart';

class RegisterScreen extends StatefulWidget {
  final Function toggleScreen;

  RegisterScreen({this.toggleScreen});
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading
        ? LoadingSpinner()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: MaterialButton(
                onPressed: () => widget.toggleScreen(),
                color: Colors.white,
                elevation: 0.0,
                child: Icon(Icons.arrow_back),
              ),
              elevation: 0.0,
              title: Text(
                'Sign up to Todo',
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Enter email' : null,
                            controller: emailController,
                            autocorrect: false,
                            onChanged: (value) {},
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                            ),
                            validator: (val) =>
                                val.length < 6 ? 'Password to short' : null,
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
                              'Sign up',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  loading = true;
                                });
                                UserModel user =
                                    await _auth.signUpWithEmailAndPassword(
                                        emailController.text,
                                        passwordController.text);

                                if (user == null) {
                                  setState(() {
                                    errorMessage = _auth.getErrorMessage;
                                    loading = false;
                                  });
                                }
                              }
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Text(
                            errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

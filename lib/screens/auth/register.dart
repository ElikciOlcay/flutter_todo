import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todoey/models/user.dart';
import 'package:todoey/widgets/loading.dart';
import 'package:todoey/services/auth.dart';
import 'package:todoey/widgets/socialmedia_button.dart';

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

  void signUpUser() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });
      UserModel user = await _auth.signUpWithEmailAndPassword(
          emailController.text, passwordController.text);

      if (user == null) {
        setState(() {
          errorMessage = _auth.getErrorMessage;
          loading = false;
        });
      }
    }
  }

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
                'Sign up to Todoey',
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            body: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
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
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width,
                            height: 50.0,
                            child: RaisedButton(
                                color: Colors.lightBlueAccent,
                                elevation: 0.0,
                                child: Text(
                                  'Sign up',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    signUpUser();
                                  }
                                }),
                          ),
                          SizedBox(
                            height: 20.0,
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

import 'package:final_gloggapp/homepage.dart';
import 'package:final_gloggapp/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String _email, _password;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        print(user);

        Navigator.pushReplacementNamed(context, "/");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
  }

  login() async {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      try {
        await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } catch (e) {
        showError(e.message);
        print(e);
      }
    }
  }

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK')),
            ],
          );
        });
  }

  navigateToSignUp() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUp()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                child: Image(
                  image: NetworkImage(
                      "https://thumbs.dreamstime.com/b/christmas-food-flat-lay-text-welcome-sign-english-walnut-hazelnut-cinnamon-sticks-orange-peel-brown-wooden-background-102712430.jpg"),
                  fit: BoxFit.contain,
                ),
              ),
              Container(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input.isEmpty)
                                return 'Enter Valid Email Address';
                            },
                            decoration: InputDecoration(
                                labelText: 'Email Address',
                                prefixIcon: Icon(Icons.email)),
                            onSaved: (input) => _email = input),
                      ),
                      Container(
                        child: TextFormField(
                            validator: (input) {
                              if (input.length < 6) return 'Password is short';
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.password),
                            ),
                            obscureText: true,
                            onSaved: (input) => _password = input),
                      ),
                      SizedBox(height: 20),
                      RaisedButton(
                        padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                        onPressed: login,
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_gloggapp/screens/homescreen.dart';
import 'package:final_gloggapp/screens/loginscreen.dart';
import 'package:final_gloggapp/screens/signupscreen.dart';

class InitialScreen extends StatefulWidget {
  InitialScreen({Key key}) : super(key: key);

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      print("Home View");
      return HomeScreen();
    }

    print("Not Authenticated");

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://www.helpguide.org/wp-content/uploads/table-with-grains-vegetables-fruit-768.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 2.5),
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blue,
              ),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 50),
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.blue,
              ),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

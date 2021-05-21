import 'package:flutter/material.dart';
import 'package:sign_button/sign_button.dart';
import 'package:final_gloggapp/login.dart';
class Start extends StatefulWidget {
  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  navigateToLogin()async
{
    Navigator.push(context, MaterialPageRoute(builder:(context)=> Login()));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 35.0),
            Container(
              height: 400,
              child: Image(
                image: NetworkImage(
                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTA2iW4TEmBYVhugwRC46zaUO6mUoN7VSLeIQ&usqp=CAU'),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  padding: EdgeInsets.only(left: 30.0, right: 30.0),
                  onPressed: navigateToLogin,
                  child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.orange,
                ),
                SizedBox(width: 20.0),
                RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.white,
                ),
              ],
            ),
            SizedBox(height: 20.0),
            SignInButton(
                buttonType: ButtonType.google,
                buttonSize: ButtonSize.small,
                onPressed: () {
                  print('click');
                })
          ],
        ),
      ),
    );
  }
}

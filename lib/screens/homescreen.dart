import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:final_gloggapp/service/authentication.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://i2.wp.com/ranchofrescomexicangrill.com/wp-content/uploads/2019/04/brooke-lark-385507-unsplash.jpg?ssl=1"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home View'),
            IconButton(
              onPressed: () {
                print("Sign Out Pressed");
                context.read<FlutterFireAuthService>().signOut();
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.black,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
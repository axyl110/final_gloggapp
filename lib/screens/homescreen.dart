import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  HomeScreen();
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  HomeScreenState();
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      body: DefaultTabController(
        length: 3,
        child: Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              width: double.infinity,
            ),
            Scaffold(
              bottomNavigationBar: Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.video_library),
                    ),
                    Tab(
                      icon: Icon(Icons.insert_drive_file),
                    ),
                    Tab(
                      icon: Icon(Icons.account_circle),
                    ),
                  ],
                  labelColor: Color(0xff8c52ff),
                  indicator: UnderlineTabIndicator(
                    borderSide:
                        BorderSide(color: Color(0xff8c52ff), width: 4.0),
                    insets: EdgeInsets.only(bottom: 44),
                  ),
                  unselectedLabelColor: Colors.grey,
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                 // VideoScreen(),
                 // AricleScreen(),
                 // ProfileScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

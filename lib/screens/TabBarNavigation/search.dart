import 'package:basic_utils/basic_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:final_gloggapp/service/database.dart';
import 'package:final_gloggapp/widgets/widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FireStoreDatabaseMethods databaseMethods = new FireStoreDatabaseMethods();

  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                searchSnapshot.docs[index],
              );
            })
        : Container();
  }

  initiateSearch() {
    databaseMethods
        .getFoodByFoodName(searchTextEditingController.text.toLowerCase())
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchTile(QueryDocumentSnapshot doc) {
    Map<String, dynamic> _tempFoodDetails = {
      "amount": doc["amount"],
      "food_name": doc["food_name"],
      "ingredients": doc["ingredients"],
      "recipe": doc["recipe"],
      "author": doc["author"],
      "image_ref": doc["image_ref"],
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                StringUtils.capitalize(_tempFoodDetails["food_name"]),
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                onTap: () {
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailScreen(
                              image: images[0],
                              foodDetails: _tempFoodDetails,
                            )),
                 ); */
                },
                child: Container(
                  width: 300.0,
                  height: 200.0,
                  child: ClipRRect(
                    child: FutureBuilder(
                      future: FireStoreDatabaseMethods.loadImageByName(
                          context, doc["image_ref"]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return snapshot.data;
                        }
                        return Container(
                          color: Colors.grey[200],
                        );
                      },
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Search Food", border: InputBorder.none),
                  )),
                  RaisedButton(
                    onPressed: () {
                      initiateSearch();
                    },
                    child: Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                  )
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

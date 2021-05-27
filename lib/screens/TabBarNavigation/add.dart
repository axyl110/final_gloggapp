import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController name = TextEditingController();
  final picker = ImagePicker();
  File imageFile;

  List<TextEditingController> ingredients = [
    TextEditingController(),
  ];
  List<TextEditingController> amount = [
    TextEditingController(),
  ];
  List<TextEditingController> recipe = [
    TextEditingController(),
  ];

  Future pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(imageFile.path);
    firebase_storage.Reference firebaseStorageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('uploads/$fileName');
    firebase_storage.UploadTask uploadTask =
        firebaseStorageRef.putFile(imageFile);
    firebase_storage.TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() => null);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.bottomLeft,
              child: Text("Publish Recipe",
                  style: new TextStyle(
                    decoration: TextDecoration.underline,
                    fontSize: 25,
                  )),
            ),
            addRecipe('Photos and videos'),
            Container(
                alignment: Alignment.bottomLeft,
                child: IconButton(
                  iconSize: 100.0,
                  icon: Icon(Icons.image_outlined),
                  onPressed: () => pickImage(),
                )),
            addRecipe('Name'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: 'Enter Recipe Name....',
                    hintStyle: TextStyle(color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.grey[400], width: 2),
                    ),
                  )),
            ),
            addRecipe('Ingredients'),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return AddIngredients(ingredients[index], amount[index]);
                  },
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: FlatButton(
                child: Text(" + Add ingredient"),
                textColor: Colors.orange,
                onPressed: () {
                  setState(() {
                    ingredients.add(TextEditingController());
                    amount.add(TextEditingController());
                  });
                },
              ),
            ),
            addRecipe('Recipe'),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: recipe.length,
                  itemBuilder: (context, index) {
                    return AddRecipe(recipe[index]);
                  },
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: FlatButton(
                child: Text(
                  "Add Recipe",
                  style: new TextStyle(fontSize: 17.0),
                ),
                textColor: Colors.orange,
                onPressed: () {
                  setState(() {
                    recipe.add(TextEditingController());
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // createFood(context);
                },
                child: Text(
                  'Submit',
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
          ],
        ),
      ),
    );
  }
}

Widget addRecipe(String text) {
  return Container(
    padding: const EdgeInsets.all(20.0),
    alignment: Alignment.bottomLeft,
    child: Text(
      text,
    ),
  );
}

class AddIngredients extends StatelessWidget {
  final TextEditingController ingredients;
  final TextEditingController amount;

  AddIngredients(this.ingredients, this.amount);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 1.6,
              child: TextFormField(
                controller: ingredients,
                decoration: InputDecoration(
                  hintText: 'Ingredients',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey[400]),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 3.2,
              child: TextFormField(
                controller: amount,
                decoration: InputDecoration(
                  hintText: 'Amount',
                  hintStyle: TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.grey[400]),
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

class AddRecipe extends StatelessWidget {
  final TextEditingController recipe;
  AddRecipe(this.recipe);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  child: TextFormField(
                    controller: recipe,
                    decoration: InputDecoration(
                      hintText: 'Recipe',
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        borderSide: BorderSide(color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ),
              ],
            )));
  }
}
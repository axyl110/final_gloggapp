import 'dart:io';

import 'package:final_gloggapp/helper/constants.dart';
import 'package:final_gloggapp/screens/homescreen.dart';
import 'package:final_gloggapp/service/database.dart';
import 'package:final_gloggapp/service/auth_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  FireStoreDatabaseMethods databaseMethods = new FireStoreDatabaseMethods();
  final _formkey = GlobalKey<FormState>();
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
  Map<String, bool> categoryCheckBox = Map.fromIterable(Categories.categories,
      key: (v) => v,
      value: (v) {
        return false;
      });

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

  createFood(BuildContext context) {
    databaseMethods.getPub(Provider.of(context).auth.getEmail().toString());
    List<String> userIngredients = new List<String>();
    List<String> userRecipe = new List<String>();
    List<String> userAmount = new List<String>();
    this.ingredients.forEach((ingredient) {
      userIngredients.add(ingredient.text.toLowerCase());
    });
    this.recipe.forEach((recipe) {
      userRecipe.add(recipe.text.toLowerCase());
    });
    this.amount.forEach((amount) {
      userAmount.add(amount.text.toLowerCase());
    });
    Map<String, dynamic> ingredientsMap = {
      "amount": userAmount,
      "food_name": name.text.toLowerCase(),
      "ingredients": userIngredients,
      "recipe": userRecipe,
      "author": Constants.myName,
      "image_ref": "uploads/${basename(imageFile.path)}",
      "email": Provider.of(context).auth.getEmail().toString()
    };
    uploadImageToFirebase(context);
    FireStoreDatabaseMethods().uploadIngredients(ingredientsMap);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
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
                ),
              ),
              Text(imageFile != null
                  ? basename(imageFile.path)
                  : "No image selected"),
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
                  ),
                  validator: (value) {
                    if (value.isEmpty) return 'Cannot be Empty';
                    return null;
                  },
                ),
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
                  textColor: Colors.blue,
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
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextButton(
                  child: Text(
                    "Add Recipe",
                    style: new TextStyle(fontSize: 17.0, color: Colors.blue),
                  ),
                  onPressed: () {
                    setState(() {
                      recipe.add(TextEditingController());
                    });
                  },
                ),
              ),
              addRecipe("Categories"),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: this.categoryCheckBox.length,
                    itemBuilder: (context, index) {
                      String _categoryName = Categories.categories[index];
                      return CheckboxListTile(
                        title: Text(_categoryName),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: this.categoryCheckBox[_categoryName],
                        onChanged: (newValue) {
                          setState(
                            () {
                              this.categoryCheckBox[_categoryName] = newValue;
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    if (imageFile == null) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Error',
                                  style: Theme.of(context).textTheme.bodyText2),
                              content: Text('No Image',
                                  style: Theme.of(context).textTheme.bodyText2),
                              actions: [
                                FlatButton(
                                  child: Text(
                                    'OK',
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop('dialog');
                                  },
                                ),
                              ],
                            );
                          });
                    } else if (_formkey.currentState.validate() &&
                        imageFile != null) {
                      createFood(context);
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: Colors.white,
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
                validator: (value) {
                  if (value.isEmpty) return 'Cannot be Empty';
                  return null;
                },
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
                validator: (value) {
                  if (value.isEmpty) return 'Cannot be Empty';
                  return null;
                },
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
                validator: (value) {
                  if (value.isEmpty) return 'Cannot be Empty';
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

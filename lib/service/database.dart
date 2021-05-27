import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_gloggapp/helper/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';


class FireStoreDatabaseMethods {
  getFoodByFoodName(String foodName) async {
    return FirebaseFirestore.instance
        .collection("food")
        .where("food_name", isEqualTo: foodName)
        .get();
  }

  getFoodByCategory(String category) async {
    return FirebaseFirestore.instance
        .collection("food")
        .where("category", arrayContains: category)
        .get();
  }

  getUserbyUserEmail(String userEmail) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: userEmail)
        .get();
  }
  void getPub(String userEmail) async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection("food")
        .where("email", isEqualTo: userEmail)
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    Constants.myPubs = _myDocCount.length.toString();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  uploadIngredients(ingredientsMap) {
    FirebaseFirestore.instance
        .collection("food")
        .add(ingredientsMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  static Future<Widget> loadImageByUrl(BuildContext context, String url) async {
    Image image;
    await FirebaseStorage.instance
        .refFromURL(url)
        .getDownloadURL()
        .then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.cover,
      );
    });
    return image;
  }

  static Future<Widget> loadImageByName(
      BuildContext context, String imgName) async {
    Image image;
    await FirebaseStorage.instance
        .ref()
        .child(imgName)
        .getDownloadURL()
        .then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.cover,
      );
    });
    return image;
  }
}

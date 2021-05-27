import 'package:final_gloggapp/others/recipe.dart';
import 'package:final_gloggapp/utils/store.dart';
import 'package:flutter/material.dart';

import '../recipe_card.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  List<Recipe> recipes = getRecipes();
  List<String> userFavorites = getFavoritesIDs();

  void _handleFavoritesListChanged(String recipeID) {
    setState(() {
      if (userFavorites.contains(recipeID)) {
        userFavorites.remove(recipeID);
      } else {
        userFavorites.add(recipeID);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Column _buildRecipes(List<Recipe> recipesList) {
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: recipesList.length,
              itemBuilder: (BuildContext context, int index) {
                return new RecipeCard(
                  recipe: recipesList[index],
                  inFavorites: userFavorites.contains(recipesList[index].id),
                  onFavoriteButtonPressed: _handleFavoritesListChanged,
                );
              },
            ),
          ),
        ],
      );
    }

    const double _iconSize = 20.0;
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.pexels.com/photos/775358/pexels-photo-775358.jpeg"),
                radius: 50,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    Text('10',
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    Text('Publications',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(width: 20.0),
                Column(
                  children: [
                    Text('132',
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    Text('Following',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(width: 20.0),
                Column(
                  children: [
                    Text('298',
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    Text('Followers',
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.only(right: 250.0),
              child: Text(
                'Favorites',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: _buildRecipes(recipes
                  .where((recipe) => userFavorites.contains(recipe.id))
                  .toList()),
            ),
          ],
        ),
      ),
    );
  }
}

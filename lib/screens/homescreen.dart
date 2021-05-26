import 'package:final_gloggapp/screens/recipe_card.dart';
import 'package:flutter/material.dart';
import 'package:final_gloggapp/utils/store.dart';
import 'package:final_gloggapp/recipe.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme.of(context).indicatorColor,
              tabs: [
                Tab(icon: Icon(Icons.home, size: _iconSize)),
                Tab(icon: Icon(Icons.search, size: _iconSize)),
                Tab(icon: Icon(Icons.add_outlined, size: _iconSize)),
                Tab(icon: Icon(Icons.list_outlined, size: _iconSize)),
                Tab(icon: Icon(Icons.emoji_emotions_outlined, size: _iconSize)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: TabBarView(
            children: [
              _buildRecipes(recipes
                  .where((recipe) => recipe.type == RecipeType.food)
                  .toList()),
              _buildRecipes(recipes
                  .where((recipe) => recipe.type == RecipeType.drink)
                  .toList()),
              Center(child: Icon(Icons.add)),
              Center(child: Icon(Icons.list_outlined)),
              _buildRecipes(recipes
                  .where((recipe) => userFavorites.contains(recipe.id))
                  .toList()), 
            ],
          ),
        ),
      ),
    );
  }
}

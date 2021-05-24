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
              Add(),
              Center(child: Icon(Icons.list_outlined)),
              Center(
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
                            Text('10', style: TextStyle(fontSize: 20.0,)),
                            Text('Publications', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          children: [
                            Text('132', style: TextStyle(fontSize: 20.0,)),
                            Text('Following', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 20.0),
                        Column(
                          children: [
                            Text('298', style: TextStyle(fontSize: 20.0,)),
                            Text('Followers', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height:20.0),
                    Padding(
                      padding: const EdgeInsets.only(right: 250.0),
                      child: Text('Favorites', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
                    ),
                    Flexible(
                    child: _buildRecipes(recipes
                          .where((recipe) => userFavorites.contains(recipe.id))
                          .toList()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Add extends StatelessWidget {
  final rName = TextEditingController(), food = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Publish Recipe",
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(
              height: 15.0,
              thickness: 3,
              indent: 5,
              endIndent: 150,
              color: Colors.black,
            ),
            SizedBox(height: 20.0),
            tField('Recipe Name', rName, 'Name'),
          ],
        ),
      ),
    );
  }
}

Widget tField(String title, TextEditingController input, String text) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        TextField(
          controller: input,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: text,
            labelStyle: TextStyle(color: Colors.white, fontSize: 20.0),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
  );
}

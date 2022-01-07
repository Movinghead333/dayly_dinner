import 'package:dayly_dinner/data_models/recipe.dart';
import 'package:sqflite/sqflite.dart';

class RecipeRepository {
  final Database _database;

  RecipeRepository(this._database);

  Future<int> insertRecipe(Recipe recipe) async {
    return await _database.insert(
      'recipes',
      recipe.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Recipe>> getAllRecipes() async {
    final List<Map<String, dynamic>> maps = await _database.query('recipes');

    return List.generate(maps.length, (i) {
      return Recipe(
        id: maps[i]['id'],
        name: maps[i]['name'],
        lastPrepared: DateTime.parse(maps[i]['lastPrepared']),
        description: maps[i]['description'],
      );
    });
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _database.update(
      'recipes',
      recipe.toJson(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  Future<void> deleteRecipe(int id) async {
    await _database.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

import 'package:dayly_dinner/data_models/ingredient.dart';
import 'package:sqflite/sqflite.dart';

class IngredientRepository {
  final Database _database;

  IngredientRepository(this._database);

  Future<int> insert(Ingredient ingredient) async {
    return await _database.insert(
      'ingredients',
      ingredient.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ingredient>> getAllIngredients() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('ingredients');

    return List.generate(maps.length, (i) {
      return Ingredient(
        id: maps[i]['id'],
        name: maps[i]['name'],
        storedAmount: maps[i]['storedAmount'],
        measurementUnit: maps[i]['measurementUnit'],
      );
    });
  }

  Future<List<Ingredient>> getIngredientsForRecipeId(int recipeId) async {
    String getIngredientsForRecipeQuery = """
      SELECT * FROM ingredients 
      INNER JOIN recipeIngredientRelation ON ingredients.id = recipeIngredientRelation.ingredientId
      WHERE ingredients.id = $recipeId
    """;

    List<Map<String, dynamic>> maps =
        await _database.rawQuery(getIngredientsForRecipeQuery);

    return List.generate(maps.length, (i) {
      return Ingredient(
        id: maps[i]['id'],
        name: maps[i]['name'],
        storedAmount: maps[i]['storedAmount'],
        measurementUnit: maps[i]['measurementUnit'],
      );
    });
  }
}

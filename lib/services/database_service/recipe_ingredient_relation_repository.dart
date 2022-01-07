import 'package:dayly_dinner/data_models/recipe_ingredient_relation.dart';
import 'package:sqflite/sqflite.dart';

class RecipeIngredientRelationRepository {
  final Database _database;

  RecipeIngredientRelationRepository(this._database);

  Future<int> insert(RecipeIngredientRelation recipeIngredientRelation) async {
    return await _database.insert(
      'recipeIngredientRelation',
      recipeIngredientRelation.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<RecipeIngredientRelation>>
      getAllRecipeIngredientRelations() async {
    final List<Map<String, dynamic>> maps =
        await _database.query('recipeIngredientRelation');

    return List.generate(maps.length, (i) {
      return RecipeIngredientRelation(
        id: maps[i]['id'],
        recipeId: maps[i]['recipeId'],
        ingredientId: maps[i]['ingredientId'],
        requiredAmount: maps[i]['requiredAmount'],
      );
    });
  }

  Future<List<RecipeIngredientRelation>>
      getRecipeIngredientRelationsForRecipeId(int recipeId) async {
    final List<Map<String, dynamic>> maps = await _database
        .query('recipeIngredientRelation', where: 'recipeId = $recipeId');

    return List.generate(maps.length, (i) {
      return RecipeIngredientRelation(
        id: maps[i]['id'],
        recipeId: maps[i]['recipeId'],
        ingredientId: maps[i]['ingredientId'],
        requiredAmount: maps[i]['requiredAmount'],
      );
    });
  }
}

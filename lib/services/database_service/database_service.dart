import 'dart:async';

import 'package:dayly_dinner/data_models/recipe.dart';
import 'package:dayly_dinner/services/database_service/database_queries.dart';
import 'package:dayly_dinner/services/database_service/ingredient_repository.dart';
import 'package:dayly_dinner/services/database_service/recipe_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  Future<Database> _database;
  late RecipeRepository recipeRepo;
  late IngredientRepository ingredientRepo;

  DatabaseService() : _database = _initializeDatabase() {
    _database.then((database) {
      recipeRepo = RecipeRepository(database);
      ingredientRepo = IngredientRepository(database);
    });
  }

  Future<void> initilizationDone() async {
    await _database;
  }

  static Future<Database> _initializeDatabase() async {
    return openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'dayly_dinner_database.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: _onCreate,
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }

  static FutureOr<void> _onCreate(Database db, int verison) async {
    debugPrint('Running db oncreate');
    // Run the CREATE TABLE statement on the database.
    await db.execute(createRecipesTableQuery);
    await db.execute(createIngredientsTableQuery);
    await db.execute(createRecipeIngredientRelationTableQuery);

    var recipes = [
      Recipe(
          name: 'Nudelsalat',
          lastPrepared: DateTime(2022, 1, 07),
          description: ''),
      Recipe(
          name: 'Pizzabrötchen',
          lastPrepared: DateTime(2022, 1, 10),
          description: ''),
      Recipe(
          name: 'Gemischter Salat mit Putenstreifen',
          lastPrepared: DateTime(2022, 1, 11),
          description: ''),
      Recipe(
          name: 'Zuccini-Nudel-Auflauf',
          lastPrepared: DateTime(2022, 1, 12),
          description: ''),
      Recipe(
          name: 'Pizzaschnecken',
          lastPrepared: DateTime(2022, 1, 13),
          description: ''),
      Recipe(
          name: 'Weißwürste mit Brezeln',
          lastPrepared: DateTime(2022, 1, 13),
          description: ''),
      Recipe(
          name: 'Fleischwurst mit Sauerkraut',
          lastPrepared: DateTime(2022, 1, 14),
          description: ''),
      Recipe(
          name: 'Burger', lastPrepared: DateTime(2022, 1, 17), description: ''),
    ];
    RecipeRepository recipeRepo = RecipeRepository(db);

    for (Recipe r in recipes) {
      await recipeRepo.insertRecipe(r);
    }

    return Future<void>.value();
  }
}

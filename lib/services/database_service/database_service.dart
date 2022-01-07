import 'package:dayly_dinner/services/database_service/database_queries.dart';
import 'package:dayly_dinner/services/database_service/ingredient_repository.dart';
import 'package:dayly_dinner/services/database_service/recipe_repository.dart';
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
      onCreate: (db, version) async {
        // Run the CREATE TABLE statement on the database.
        await db.execute(createRecipesTableQuery);
        await db.execute(createIngredientsTableQuery);
        await db.execute(createRecipeIngredientRelationTableQuery);
        return Future<void>.value();
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
  }
}

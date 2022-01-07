import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.
  // final database = openDatabase(
  //   // Set the path to the database. Note: Using the `join` function from the
  //   // `path` package is best practice to ensure the path is correctly
  //   // constructed for each platform.
  //   join(await getDatabasesPath(), 'dayly_dinner_database4.db'),
  //   // When the database is first created, create a table to store dogs.
  //   onCreate: (db, version) async {
  //     // Run the CREATE TABLE statement on the database.
  //     await db.execute(createRecipesTableQuery);
  //     await db.execute(createIngredientsTableQuery);
  //     await db.execute(createRecipeIngredientRelationTableQuery);
  //     return Future<void>.value();
  //   },
  //   // Set the version. This executes the onCreate function and provides a
  //   // path to perform database upgrades and downgrades.
  //   version: 1,
  // );

  // // Define a function that inserts dogs into the database
  // Future<void> insertDog(Dog dog) async {
  //   // Get a reference to the database.
  //   final db = await database;

  //   // Insert the Dog into the correct table. You might also specify the
  //   // `conflictAlgorithm` to use in case the same dog is inserted twice.
  //   //
  //   // In this case, replace any previous data.
  //   await db.insert(
  //     'dogs',
  //     dog.toMap(),
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  // }

  // // A method that retrieves all the dogs from the dogs table.
  // Future<List<Dog>> dogs() async {
  //   // Get a reference to the database.
  //   final db = await database;

  //   // Query the table for all The Dogs.
  //   final List<Map<String, dynamic>> maps = await db.query('dogs');

  //   // Convert the List<Map<String, dynamic> into a List<Dog>.
  //   return List.generate(maps.length, (i) {
  //     return Dog(
  //       id: maps[i]['id'],
  //       name: maps[i]['name'],
  //       age: maps[i]['age'],
  //     );
  //   });
  // }

  // Future<void> updateDog(Dog dog) async {
  //   // Get a reference to the database.
  //   final db = await database;

  //   // Update the given Dog.
  //   await db.update(
  //     'dogs',
  //     dog.toMap(),
  //     // Ensure that the Dog has a matching id.
  //     where: 'id = ?',
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [dog.id],
  //   );
  // }

  // Future<void> deleteDog(int id) async {
  //   // Get a reference to the database.
  //   final db = await database;

  //   // Remove the Dog from the database.
  //   await db.delete(
  //     'dogs',
  //     // Use a `where` clause to delete a specific dog.
  //     where: 'id = ?',
  //     // Pass the Dog's id as a whereArg to prevent SQL injection.
  //     whereArgs: [id],
  //   );
  // }

  // Recipe pizza = Recipe(
  //   name: 'Pizza',
  //   lastPrepared: '2021-08-07',
  //   description: 'Teig ausrollen, Belag drauf und in den Ofen.',
  // );

  // Ingredient schinken = Ingredient(
  //   name: 'Schinken',
  //   storedAmount: 200.0,
  //   measurementUnit: 'g',
  // );

  // Database db = await database;

  // int recipeId = await Recipe.insert(db, pizza);
  // int ingredientId = await Ingredient.insert(db, schinken);
  // RecipeIngredientRelation recipeIngredientRelation = RecipeIngredientRelation(
  //     recipeId: recipeId, ingredientId: ingredientId, requiredAmount: 200.0,);
  // await RecipeIngredientRelation.insert(db, recipeIngredientRelation);

  // print(await Recipe.getAllRecipes(db));
  // print(await Ingredient.getAllIngredients(db));
  // print(await RecipeIngredientRelation.getAllRecipeIngredientRelations(db));

  // print('relations for recipe:\n');
  // print(await RecipeIngredientRelation.getRecipeIngredientRelationsForRecipeId(db, recipeId));

  // print('ingredients for recipe:\n');
  // print(await Ingredient.getIngredientsForRecipeId(db, recipeId));
}

class Dog {
  final int id;
  final String name;
  final int age;

  Dog({
    required this.id,
    required this.name,
    required this.age,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}

import 'package:dayly_dinner/data_models/recipe.dart';
import 'package:dayly_dinner/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class MainDataProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  final FlutterSecureStorage storage = FlutterSecureStorage();

  /// Index of the recipe which has been selected most recently.
  int selectedRecipeIndex = -1;

  /// Initializes the RecipesModel by loading recipes from database
  MainDataProvider() {
    // load recipes from database
    _loadRecipes();
  }

  /// Load recipes from json-encoded string in flutter-secure-storage
  void _loadRecipes() async {
    debugPrint('${DateTime.now().toString()} loading recipes');

    this._recipes = await Services.databaseService.recipeRepo.getAllRecipes();
    _recipes.sort();
    notifyListeners();
    debugPrint('${DateTime.now().toString()} loading recipes done');
  }

  /// Add a recipe based on the passed recipeName and add along with the current
  /// date as recipe to the list.
  void addRecipe(String? recipeName) async {
    //TODO: implement unique constraint
    if (recipeName != null && recipeName != '') {
      DateTime now = DateTime.now();
      Recipe newRecipe =
          Recipe(name: recipeName, lastPrepared: now, description: '');

      Services.databaseService.recipeRepo.insertRecipe(newRecipe);
      _recipes.add(newRecipe);
      _recipes.sort();
      notifyListeners();
    }
  }

  String getCurrentRecipeName() {
    return _recipes[selectedRecipeIndex].name;
  }

  String getCurrentRecipeLastPreparedToString() {
    return _recipes[selectedRecipeIndex].lastPreparedToString();
  }

  void deleteCurrentRecipe() {
    Recipe removedRecipe = _recipes.removeAt(selectedRecipeIndex);
    Services.databaseService.recipeRepo.deleteRecipe(removedRecipe.id);
    selectedRecipeIndex = -1;
    notifyListeners();
  }

  void cookCurrentRecipe() {
    Recipe updatedRecipe = _recipes[selectedRecipeIndex];
    updatedRecipe.lastPrepared = DateTime.now();
    Services.databaseService.recipeRepo.updateRecipe(updatedRecipe);
    _recipes.sort();
    notifyListeners();
  }

  bool updateCurrentRecipe(String? updatedRecipeName, String? newDate) {
    Recipe currentRecipe = _recipes[selectedRecipeIndex];

    if (updatedRecipeName != null &&
        newDate != null &&
        updatedRecipeName != '' &&
        (currentRecipe.name == updatedRecipeName ||
            _checkUniqueRecipeNameConstraint(updatedRecipeName))) {
      try {
        DateTime updatedLastPrepared =
            DateFormat('dd.MM.yyyy').parseStrict(newDate);
        currentRecipe.name = updatedRecipeName;
        currentRecipe.lastPrepared = updatedLastPrepared;
        Services.databaseService.recipeRepo.updateRecipe(currentRecipe);
        _recipes.sort();
        notifyListeners();
        return true;
      } on FormatException {
        return false;
      }
    } else {
      print('else case');
      print(_checkUniqueRecipeNameConstraint(updatedRecipeName!));
      return false;
    }
  }

  /// Returns true if the given [newRecipeName] is unique within the already
  /// existing recipe names in _recipes.
  bool _checkUniqueRecipeNameConstraint(String newRecipeName) {
    for (Recipe recipe in _recipes) {
      if (recipe.name == newRecipeName) {
        return false;
      }
    }
    return true;
  }
}

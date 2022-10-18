import 'package:dayly_dinner/constants.dart';
import 'package:dayly_dinner/data_models/recipe.dart';
import 'package:dayly_dinner/services/services.dart';
import 'package:dayly_dinner/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class MainDataProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get filteredRecipes {
    if (_recipeSearchQuery == '') {
      return _recipes;
    } else {
      return _recipes
          .where((Recipe recipe) =>
              recipe.name.toLowerCase().contains(_recipeSearchQuery))
          .toList();
    }
  }

  String _recipeSearchQuery = '';

  final FlutterSecureStorage storage = FlutterSecureStorage();

  /// Reference to the most recently selected [Recipe].
  Recipe? _selectedRecipe;

  set setSelectedRecipe(Recipe recipe) => _selectedRecipe = recipe;

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

  void setRecipeSearchQuery(String queryString) {
    _recipeSearchQuery = queryString.toLowerCase();

    notifyListeners();
  }

  /// Add a recipe based on the passed recipeName and add along with the current
  /// date as recipe to the list.
  bool addRecipe(String recipeName, String lastPreparedString) {
    DateTime? lastPrepared =
        Utility.parseStringDateToDateTime(lastPreparedString);

    if (recipeName == '') {
      Utility.showToast(kPleaseEnterARecipeName);
      return false;
    }

    if (!_checkUniqueRecipeNameConstraint(recipeName)) {
      Utility.showToast(kARecipeWithThisNameAlreadyExists);
      return false;
    }

    if (lastPrepared == null) {
      Utility.showToast(kPleaseEnterAValidDate);
      return false;
    }

    Recipe newRecipe = Recipe(
      name: recipeName,
      lastPrepared: lastPrepared,
      description: '',
    );

    Services.databaseService.recipeRepo.insertRecipe(newRecipe);
    _recipes.add(newRecipe);
    _recipes.sort();
    notifyListeners();
    return true;
  }

  String getCurrentRecipeName() {
    return _selectedRecipe?.name ?? 'Kein Rezept ausgewählt';
  }

  String getCurrentRecipeLastPreparedToString() {
    return _selectedRecipe?.lastPreparedToString() ?? '-';
  }

  void deleteCurrentRecipe() {
    _recipes.remove(_selectedRecipe!);
    Services.databaseService.recipeRepo.deleteRecipe(_selectedRecipe!.id);
    notifyListeners();
  }

  void cookCurrentRecipe() {
    _selectedRecipe!.lastPrepared = DateTime.now();
    Services.databaseService.recipeRepo.updateRecipe(_selectedRecipe!);
    _recipes.sort();
    notifyListeners();
  }

  bool updateCurrentRecipe(String? updatedRecipeName, String? newDate) {
    Recipe currentRecipe = _selectedRecipe!;

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

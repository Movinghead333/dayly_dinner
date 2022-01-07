class RecipeIngredientRelation {
  final int id;
  final int recipeId;
  final int ingredientId;
  final double requiredAmount;

  RecipeIngredientRelation({
    this.id = -1,
    required this.recipeId,
    required this.ingredientId,
    required this.requiredAmount,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'recipeId': recipeId,
      'ingredientId': ingredientId,
      'requiredAmount': requiredAmount,
    };

    if (id != -1) {
      map['id'] = id;
    }

    return map;
  }

  @override
  String toString() {
    return 'RecipeIngredientRelation{id: $id, recipeId: $recipeId, ingredientId: $ingredientId, requiredAmount: $requiredAmount}';
  }
}

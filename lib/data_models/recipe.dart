class Recipe implements Comparable<Recipe> {
  final int id;
  String name;
  DateTime lastPrepared;
  final String description;

  Recipe({
    this.id = -1,
    required this.name,
    required this.lastPrepared,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'name': name,
      'lastPrepared': lastPrepared.toIso8601String(),
      'description': description,
    };

    if (id != -1) {
      map['id'] = id;
    }

    return map;
  }

  String lastPreparedToString() {
    return '${lastPrepared.day}.${lastPrepared.month}.${lastPrepared.year}';
  }

  @override
  int compareTo(Recipe otherRecipe) {
    return lastPrepared.compareTo(otherRecipe.lastPrepared);
  }

  Recipe.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        lastPrepared = DateTime.parse(json['lastPrepared']),
        description = json['description'];

  @override
  String toString() {
    return 'Recipe{id: $id, name: $name, lastPrepared: $lastPrepared, description: $description}';
  }
}

// class Recipe implements Comparable<Recipe> {
//   String recipeName;
//   DateTime lastPrepared;

//   Recipe({required this.recipeName, required this.lastPrepared});

//   String lastPreparedToString() {
//     return '${lastPrepared.day}.${lastPrepared.month}.${lastPrepared.year}';
//   }

//   @override
//   int compareTo(Recipe otherRecipe) {
//     return lastPrepared.compareTo(otherRecipe.lastPrepared);
//   }

//   Recipe.fromJson(Map<String, dynamic> json)
//       : recipeName = json['recipeName'],
//         lastPrepared = DateTime.parse(json['lastPrepared']);

// }

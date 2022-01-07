const String createRecipesTableQuery = """
  CREATE TABLE recipes(
    id INTEGER PRIMARY KEY,
    name TEXT,
    lastPrepared TEXT,
    description TEXT
  );
""";

const String createIngredientsTableQuery = """
  CREATE TABLE ingredients(
    id INTEGER PRIMARY KEY,
    name TEXT,
    storedAmount REAL,
    measurementUnit TEXT
  );
""";

const String createRecipeIngredientRelationTableQuery = """
  CREATE TABLE recipeIngredientRelation(
    id INTEGER PRIMARY KEY,
    recipeId INTEGER,
    ingredientId INTEGER,
    requiredAmount REAL,
    FOREIGN KEY (recipeId) REFERENCES recipes (id)
      ON DELETE NO ACTION ON UPDATE NO ACTION,
    FOREIGN KEY (ingredientId) REFERENCES recipes (id)
      ON DELETE NO ACTION ON UPDATE NO ACTION
  );
""";

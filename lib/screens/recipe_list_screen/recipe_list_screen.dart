import 'package:dayly_dinner/constants.dart';
import 'package:dayly_dinner/data_models/recipe.dart';
import 'package:dayly_dinner/providers/main_data_provider.dart';
import 'package:dayly_dinner/widgets/confirmation_dialog.dart';
import 'package:dayly_dinner/widgets/recipe_add_or_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dayly_dinner/utility.dart';

class RecipeListScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  TextEditingController recipeSearchController = TextEditingController();

  List<Recipe> shownRecipes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          DateTime now = DateTime.now();
          TextEditingController recipeNameTEC = TextEditingController();
          TextEditingController lastPreparedTEC = TextEditingController();
          lastPreparedTEC.text = Utility.parseDateTimeToGerDateString(now);
          await showDialog(
            context: context,
            builder: (context) {
              return RecipeAddOrEditDialog(
                title: kAddRecipe,
                recipeNameTEC: recipeNameTEC,
                lastPreparedTEC: lastPreparedTEC,
                onConfirm: () {
                  String newRecipeName = recipeNameTEC.text;
                  String lastPreparedString = lastPreparedTEC.text;
                  bool addingRecipeSuccessful =
                      Provider.of<MainDataProvider>(context, listen: false)
                          .addRecipe(newRecipeName, lastPreparedString);

                  if (addingRecipeSuccessful) {
                    Navigator.pop(context);
                  }
                },
                onCancel: () {
                  Navigator.pop(context);
                },
              );
            },
          );
        },
      ),
      body: Consumer<MainDataProvider>(
        builder: (context, recipesModel, child) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: TextField(
                  onChanged: (String value) {
                    print('change');
                    Provider.of<MainDataProvider>(context, listen: false)
                        .setRecipeSearchQuery(value);
                  },
                  controller: recipeSearchController,
                  decoration: InputDecoration(hintText: kSearchRecipe),
                ),
              ),
              Expanded(
                child: _buildRecipesList(recipesModel),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRecipesList(MainDataProvider recipesModel) {
    List<Recipe> recipes = recipesModel.filteredRecipes;
    return ListView.builder(
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Theme.of(context).colorScheme.surface),
          child: ListTile(
            title: Text(recipes[index].name),
            subtitle: Text(
                '$kLastPreparedOn: ${recipes[index].lastPreparedToString()}'),
            onTap: () {
              recipesModel.selectedRecipeIndex = index;
              showRecipeActionsDialog(
                  context: context, recipesModel: recipesModel);
            },
          ),
        );
      },
    );
  }

  void showRecipeActionsDialog(
      {required BuildContext context, required MainDataProvider recipesModel}) {
    showDialog(
      context: context,
      builder: (context) {
        return RecipeActionsDialog();
      },
    );
  }
}

class RecipeActionsDialog extends StatefulWidget {
  RecipeActionsDialog();

  @override
  _RecipeActionsDialogState createState() => _RecipeActionsDialogState();
}

class _RecipeActionsDialogState extends State<RecipeActionsDialog> {
  @override
  Widget build(BuildContext context) {
    MainDataProvider recipesModel = context.read<MainDataProvider>();
    return SimpleDialog(
      contentPadding: EdgeInsets.all(10),
      title: Text(recipesModel.getCurrentRecipeName()),
      children: [
        SimpleDialogButton(
          buttonText: kCookRecipe,
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (context) {
                return ConfirmationDialog(
                  title: kCookRecipe,
                  content:
                      '$kTheLastPreparedDateWillBeSetTo1 ${recipesModel.getCurrentRecipeName()} $kTheLastPreparedDateWillBeSetTo2 ${Utility.getCurrentDateAsString()} $kTheLastPreparedDateWillBeSetTo3.',
                  onDialogConfirmed: () {
                    recipesModel.cookCurrentRecipe();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  onDialogCanceled: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
        SimpleDialogButton(
          buttonText: kEditRecipe,
          onPressed: () async {
            TextEditingController recipeNameController =
                TextEditingController();
            recipeNameController.text = recipesModel.getCurrentRecipeName();
            TextEditingController lastPreparedController =
                TextEditingController();
            lastPreparedController.text =
                recipesModel.getCurrentRecipeLastPreparedToString();
            await showDialog(
              context: context,
              builder: (context) {
                return RecipeAddOrEditDialog(
                  title: kEditRecipe,
                  recipeNameTEC: recipeNameController,
                  lastPreparedTEC: lastPreparedController,
                  onConfirm: () {
                    if (recipesModel.updateCurrentRecipe(
                        recipeNameController.text,
                        lastPreparedController.text)) {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }
                  },
                  onCancel: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
        SimpleDialogButton(
          buttonText: kDeleteRecipe,
          onPressed: () async {
            await showDialog(
              //TODO: finish delete recipe confirmation dialog
              context: context,
              builder: (context) {
                return ConfirmationDialog(
                  title: kDeleteRecipe,
                  content:
                      '$kTheFollowingRecipeWillBeDeleted: ${recipesModel.getCurrentRecipeName()}',
                  onDialogConfirmed: () {
                    recipesModel.deleteCurrentRecipe();
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  onDialogCanceled: () {
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
        SimpleDialogButton(
          buttonText: kCancel,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class SimpleDialogButton extends StatelessWidget {
  final String buttonText;
  final Function()? onPressed;

  SimpleDialogButton({required this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        buttonText,
      ),
      onPressed: onPressed,
    );
  }
}

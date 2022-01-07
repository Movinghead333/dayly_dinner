import 'package:dayly_dinner/constants.dart';
import 'package:dayly_dinner/data_models/recipe.dart';
import 'package:dayly_dinner/providers/main_data_provider.dart';
import 'package:dayly_dinner/widgets/confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dayly_dinner/utility.dart';

class RecipeListScreen extends StatefulWidget {
  static const String routeName = '/';

  @override
  _RecipeListScreenState createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          TextEditingController _textFieldController = TextEditingController();
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(kAddRecipe),
                content: TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(hintText: kRecipeName),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                    child: Text(kAdd),
                    onPressed: () {
                      print(_textFieldController.text);
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                    child: Text(kCancel),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
          String newRecipeName = _textFieldController.text;
          Provider.of<MainDataProvider>(context, listen: false)
              .addRecipe(newRecipeName);
        },
      ),
      body: Consumer<MainDataProvider>(
        builder: (context, recipesModel, child) {
          List<Recipe> recipes = recipesModel.recipes;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(recipes[index].name),
                subtitle: Text(
                    '$kLastPreparedOn: ${recipes[index].lastPreparedToString()}'),
                onTap: () {
                  recipesModel.selectedRecipeIndex = index;
                  showRecipeActionsDialog(
                      context: context, recipesModel: recipesModel);
                },
              );
            },
          );
        },
      ),
    );
  }

  void showRecipeActionsDialog(
      {required BuildContext context, required MainDataProvider recipesModel}) {
    showDialog(
      context: context,
      builder: (context) {
        return RecipeActionsDialog(recipesModel: recipesModel);
      },
    );
  }
}

class RecipeActionsDialog extends StatefulWidget {
  final MainDataProvider recipesModel;

  RecipeActionsDialog({required this.recipesModel});

  @override
  _RecipeActionsDialogState createState() => _RecipeActionsDialogState();
}

class _RecipeActionsDialogState extends State<RecipeActionsDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: EdgeInsets.all(10),
      title: Text(widget.recipesModel.getCurrentRecipeName()),
      children: [
        SimpleDialogButton(
          buttonText: kCookRecipe,
          onPressed: () async {
            await showDialog(
              //TODO: finish delete recipe confirmation dialog
              context: context,
              builder: (context) {
                return ConfirmationDialog(
                  title: kCookRecipe,
                  content:
                      '$kTheLastPreparedDateWillBeSetTo1 ${widget.recipesModel.getCurrentRecipeName()} $kTheLastPreparedDateWillBeSetTo2 ${Utility.getCurrentDateAsString()} $kTheLastPreparedDateWillBeSetTo3.',
                  onDialogConfirmed: () {
                    widget.recipesModel.cookCurrentRecipe();
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
            recipeNameController.text =
                widget.recipesModel.getCurrentRecipeName();
            TextEditingController lastPreparedController =
                TextEditingController();
            lastPreparedController.text =
                widget.recipesModel.getCurrentRecipeLastPreparedToString();
            await showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(kEditRecipe),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$kRecipeName:'),
                          TextField(
                            controller: recipeNameController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('$kLastPreparedOn:'),
                          TextField(
                            controller: lastPreparedController,
                          ),
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightBlue),
                          ),
                          onPressed: () {
                            if (widget.recipesModel.updateCurrentRecipe(
                                recipeNameController.text,
                                lastPreparedController.text)) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(kConfirm),
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightBlue),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(kCancel),
                        ),
                      ],
                    )
                  ],
                );
              },
            );
            //setState(() {});
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
                      '$kTheFollowingRecipeWillBeDeleted: ${widget.recipesModel.getCurrentRecipeName()}',
                  onDialogConfirmed: () {
                    widget.recipesModel.deleteCurrentRecipe();
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
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

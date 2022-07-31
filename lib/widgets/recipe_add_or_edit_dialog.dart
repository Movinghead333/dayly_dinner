import 'package:dayly_dinner/constants.dart';
import 'package:flutter/material.dart';

class RecipeAddOrEditDialog extends StatelessWidget {
  final String title;
  final TextEditingController recipeNameTEC;
  final TextEditingController lastPreparedTEC;
  final void Function() onConfirm;
  final void Function() onCancel;

  const RecipeAddOrEditDialog({
    required this.title,
    required this.recipeNameTEC,
    required this.lastPreparedTEC,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(title),
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$kRecipeName:'),
              TextField(
                controller: recipeNameTEC,
              ),
              SizedBox(
                height: 20,
              ),
              Text('$kLastPreparedOn:'),
              TextField(
                controller: lastPreparedTEC,
              ),
            ],
          ),
        ),
        ButtonBar(
          children: [
            ElevatedButton(
              onPressed: onConfirm,
              child: Text(kConfirm),
            ),
            ElevatedButton(
              onPressed: onCancel,
              child: Text(kCancel),
            ),
          ],
        )
      ],
    );
  }
}

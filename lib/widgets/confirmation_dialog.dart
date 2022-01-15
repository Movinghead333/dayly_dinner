import 'package:dayly_dinner/constants.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final void Function()? onDialogConfirmed;
  final void Function()? onDialogCanceled;

  const ConfirmationDialog({
    required this.title,
    required this.content,
    required this.onDialogConfirmed,
    required this.onDialogCanceled,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        ElevatedButton(child: Text(kConfirm), onPressed: onDialogConfirmed),
        ElevatedButton(
          child: Text(kCancel),
          onPressed: onDialogCanceled,
        ),
      ],
    );
  }
}

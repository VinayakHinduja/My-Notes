import 'generic_dialogue.dart';
import 'package:flutter/material.dart';

Future<bool> showDeleteDialogue(BuildContext context) {
  return showGenericDialogue<bool>(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this item ? ',
    optionBuilder: () => {
      'No': false,
      'Yes': true,
    },
  ).then((value) => value ?? false);
}

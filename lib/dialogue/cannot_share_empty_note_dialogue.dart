import 'package:flutter/material.dart';

import 'generic_dialogue.dart';

Future<void> showCannotShareEmptyNoteDialogue(BuildContext context) {
  return showGenericDialogue(
    context: context,
    title: 'Sharing',
    content: 'You cannot share Empty note !',
    optionBuilder: () => {'OK': null},
  );
}

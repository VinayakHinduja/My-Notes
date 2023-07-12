import 'package:flutter/material.dart';

import 'generic_dialogue.dart';

Future<void> showPasswordUpdateDialog(BuildContext context) {
  return showGenericDialogue(
    context: context,
    title: 'Username Updated',
    content: 'Your Password has been updated',
    optionBuilder: () => {'OK': null},
  );
}

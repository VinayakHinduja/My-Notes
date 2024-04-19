import 'package:flutter/material.dart';

import 'generic_dialogue.dart';

Future<void> showUsernameUpdatedDialog(BuildContext context) {
  return showGenericDialogue(
    context: context,
    title: 'Username Updated',
    content: 'Your Username has been updated',
    optionBuilder: () => {'OK': null},
  );
}

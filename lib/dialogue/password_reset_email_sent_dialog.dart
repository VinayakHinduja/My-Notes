import 'package:flutter/material.dart';

import 'generic_dialogue.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialogue(
    context: context,
    title: 'Password Reset',
    content: 'We have sent you password reset Link ,please check your email',
    optionBuilder: () => {'OK': null},
  );
}

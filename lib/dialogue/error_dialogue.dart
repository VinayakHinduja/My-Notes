import 'generic_dialogue.dart';
import 'package:flutter/cupertino.dart';

Future<void> showErrorDialogue(
  BuildContext context,
  String text,
) {
  return showGenericDialogue<void>(
    context: context,
    title: 'An Error occurred',
    content: text,
    optionBuilder: () => {'OK': null},
  );
}

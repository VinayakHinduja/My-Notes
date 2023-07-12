import 'package:flutter/material.dart';

typedef DialogueOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialogue<T>({
  required BuildContext context,
  required String title,
  required String content,
  required DialogueOptionBuilder optionBuilder,
}) {
  final options = optionBuilder();
  return showDialog<T>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              title,
              textAlign: TextAlign.center,
            ),
          ),
          titleTextStyle: const TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          content: Text(
            content,
            textAlign: TextAlign.center,
          ),
          contentTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          actions: options.keys.map((optionTitle) {
            final value = options[optionTitle];
            return TextButton(
              onPressed: () {
                if (value != null) {
                  Navigator.of(context).pop(value);
                } else {
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                optionTitle,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        );
      });
}

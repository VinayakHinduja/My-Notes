// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../widgets/constants.dart';

Future<bool> showDeleteAccDialogue(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Delete Account !!',
            textAlign: TextAlign.center,
          ),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 30,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        content: const Text(
          'Are you sure You want to Delete your Account ? '
          'Once Deleted your data cannot be retrieved no matter what !!',
          textAlign: TextAlign.center,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 25,
          color: Colors.grey,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              kYesButton(context, true),
              kSpacer(),
              kNoButton(context, false),
            ],
          ),
          const SizedBox(height: 5),
        ],
      );
    },
  ).then((value) => value ?? false);
}

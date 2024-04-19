import 'package:flutter/material.dart';

import '../widgets/constants.dart';

Future<bool> showLogOutDialogue(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Center(
          child: Text(
            'Log out',
            textAlign: TextAlign.center,
          ),
        ),
        titleTextStyle: const TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        content: const Text(
          'Are you sure You want to logout ?',
          textAlign: TextAlign.center,
        ),
        contentTextStyle: const TextStyle(
          fontSize: 25.0,
          color: Colors.grey,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                  kFlutterToast('You have been Logged out');
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              kSpacer(),
              kNoButton(context, false),
            ],
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

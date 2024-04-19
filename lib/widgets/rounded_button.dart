// ignore_for_file: unnecessary_null_comparison, must_be_immutable

import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton({
    super.key,
    required this.color,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final Function() onPressed;
  Color color;

  Color getColor() {
    if (color == Colors.transparent) {
      return Colors.black87;
    } else {
      return color;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: getColor(),
        borderRadius: BorderRadius.circular(15.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200,
          height: 42,
          child: Text(
            text,
            style: const TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

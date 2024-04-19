import 'package:flutter/material.dart';

import '/services/cloud/cloud_note.dart';

Widget noteCard({
  required Function()? onTap,
  required Function()? onLongPress,
  required CloudNote note,
}) {
  return InkWell(
    onLongPress: onLongPress,
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Text(
            note.time,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

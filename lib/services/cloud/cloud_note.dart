import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cloud_storage_constants.dart' as consts;

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;
  final String time;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
    required this.time,
  });

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[consts.ownerUserIdFieldName],
        text = snapshot.data()[consts.textFieldName] as String,
        time = snapshot.data()[consts.time].toString();
}

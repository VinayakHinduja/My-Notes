import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'cloud_storage_constants.dart';
import 'cloud_storage_exceptions.dart';
import 'cloud_note.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  DateFormat formatter = DateFormat("d MMMM, yyyy").add_jm();

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNote();
    }
  }

  Future<void> updateNote(
      {required String documentId, required String text}) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
        time: formatter.format(DateTime.now()),
      });
    } catch (e) {
      throw CouldNotUpdateNote();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Future<CloudNote> createNewNote(
      {required String ownerUserId, required String text}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: text,
      time: formatter.format(DateTime.now()),
    });
    final fetchNote = await document.get();
    return CloudNote(
      documentId: fetchNote.id,
      ownerUserId: ownerUserId,
      text: textFieldName,
      time: formatter.format(DateTime.now()),
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}

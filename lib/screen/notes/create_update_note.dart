// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:developer' as devtools show log;

import '../../dialogue/cannot_share_empty_note_dialogue.dart';
import '/generics/get_arguments.dart';
import '../../services/auth/auth_services.dart';
import '../../services/cloud/cloud_note.dart';
import '../../services/cloud/firebase_cloud_storage.dart';

class CreateUpdateNoteView extends StatefulWidget {
  static const String id = 'new_notes_screen';

  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final loggedInUser;
  late FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
  }

  void getCurrentUser() {
    try {
      final user = AuthService.firebase().currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      devtools.log('from get user in create update note');
      devtools.log(e.runtimeType.toString());
    }
  }

  Future<CloudNote?> getData(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _textController.text = widgetNote.text;
      _note = widgetNote;
      return widgetNote;
    } else {
      return null;
    }
  }

  Future<CloudNote?> createNewNote({required String text}) async {
    try {
      final id = loggedInUser!.uid;
      final note =
          await _notesService.createNewNote(ownerUserId: id, text: text);
      _note = note;
      return _note;
    } catch (e) {
      devtools.log(e.runtimeType.toString());
      return null;
    }
  }

  void _saveNoteIfNotEmptyOrUpdate() async {
    final texts = _textController.text;
    if (texts.isNotEmpty) {
      if (_note != null) {
        await _notesService.updateNote(
            documentId: _note!.documentId, text: texts);
      } else {
        if (texts.isNotEmpty) {
          createNewNote(text: texts);
          _textController.clear();
        }
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text(
            'New note',
            style: TextStyle(color: Colors.black),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialogue(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(
                Icons.share_outlined,
                color: Colors.black,
              ),
            ),
            IconButton(
                onPressed: () {
                  _saveNoteIfNotEmptyOrUpdate();
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.done,
                  color: Colors.black,
                ))
          ],
        ),
        body: FutureBuilder(
          future: getData(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    cursorWidth: 3,
                    cursorHeight: 25,
                    cursorColor: Colors.blueGrey,
                    maxLines: null,
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 25),
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(fontSize: 20),
                      hintText: 'Start Typing ...',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

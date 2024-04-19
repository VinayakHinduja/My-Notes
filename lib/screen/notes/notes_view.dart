import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dart:developer' as devtools show log;

import 'create_update_note.dart';

import 'package:my_notes/services/bloc.dart';

import 'package:my_notes/widgets/widgets.dart';

import '/services/cloud/firebase_cloud_storage.dart';
import '/services/cloud/cloud_note.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  DateTime timeBackPressed = DateTime.now();
  late final FirebaseCloudStorage _notesService;
  AuthUser? loggedInUser;

  @override
  void initState() {
    super.initState();
    _notesService = FirebaseCloudStorage();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = AuthService.firebase().currentUser;
      if (user != null) {
        loggedInUser = user;
      } else {
        context.read<AuthBloc>().add(const AuthEventLogOut());
      }
    } catch (e) {
      devtools.log('from get user in my notes screen');
      devtools.log(e.runtimeType.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = loggedInUser!.uid;
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () =>
                context.read<AuthBloc>().add(const AuthEventSettings()),
            icon: const Icon(
              Icons.more_vert_sharp,
              color: Colors.black,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () => Navigator.pushNamed(context, CreateUpdateNoteView.id),
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (ctx, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                          MediaQuery.of(context).size.width >= 400 ? 350 : 250,
                      childAspectRatio: 3.2 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    children: allNotes
                        .map(
                          (not) => noteCard(
                            onTap: () => Navigator.pushNamed(
                              context,
                              CreateUpdateNoteView.id,
                              arguments: not,
                            ),
                            note: not,
                            onLongPress: () async => await _notesService
                                .deleteNote(documentId: not.documentId),
                          ),
                        )
                        .toList(),
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

/*

NotesListView(
                    notes: allNotes,
                    onDeleteNote: (note) async => await _notesService
                        .deleteNote(documentId: note.documentId),
                    onTap: (note) => Navigator.pushNamed(
                      context,
                      CreateUpdateNoteView.id,
                      arguments: note,
                    ),
                  );

 */
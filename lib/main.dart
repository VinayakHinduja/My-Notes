import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_notes/helpers/loading/loading_screen.dart';
import 'package:my_notes/services/auth/firebase_auth_provider.dart';
import 'package:my_notes/screen/screens.dart';

import 'package:my_notes/services/bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const MyNotes(),
      ),
      routes: {
        CreateUpdateNoteView.id: (context) => const CreateUpdateNoteView(),
      },
    );
  }
}

class MyNotes extends StatelessWidget {
  const MyNotes({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state.isLoading) {
        LoadingScreen().show(
          context: context,
          text: state.loadingText ?? 'Please wait a moment',
        );
      } else {
        LoadingScreen().hide();
      }
    }, builder: (context, state) {
      if (state is AuthStateLoggedIn) {
        return const NotesScreen();
      } else if (state is AuthStateNeedsVerification) {
        return const VerificationScreen();
      } else if (state is AuthStateForgotPassword) {
        return const ForgotPasswordScreen();
      } else if (state is AuthStateLoggedOut) {
        return const LoginScreen();
      } else if (state is AuthStateSettings) {
        return const MyAccountScreen();
      } else if (state is AuthStateUpdatePassword) {
        return const UpdatePasswordScreen();
      } else if (state is AuthStateUpdateUsername) {
        return const UpdateUsernameScreen();
      } else if (state is AuthStateRegistering) {
        return const RegistrationScreen();
      } else {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
    });
  }
}

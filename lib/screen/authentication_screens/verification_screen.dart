import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_notes/services/bloc.dart';

import 'package:my_notes/widgets/widgets.dart';

import 'package:my_notes/dialogue/dialogue.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception is TooManyRequests) {
            showErrorDialogue(context,
                'The Verification Email has been already sent ,you might wanna check your spam');
          } else if (state.exception is AnyOtherException) {
            showErrorDialogue(context, 'Authentication Error');
          }
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                klogo(),
                const SizedBox(height: 48.0),
                kDefaultText('Verification'),
                const SizedBox(height: 34.0),
                Hero(
                  tag: 'Register',
                  child: RoundedButton(
                    text: 'Verify',
                    color: Colors.transparent,
                    onPressed: () async {
                      context
                          .read<AuthBloc>()
                          .add(const AuthEventSendEmailVerification());
                      kFlutterToast("The Verification Email has been sent");
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      context.read<AuthBloc>().add(const AuthEventLogOut()),
                  child: const Text(
                    'Back to Login',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

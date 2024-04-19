// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_notes/dialogue/dialogue.dart';

import 'package:my_notes/services/bloc.dart';

import 'package:my_notes/widgets/widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // ignore: prefer_typing_uninitialized_variables
  late final _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final padding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          klogo(),
          const SizedBox(height: 48.0),
          kHero('forgotPassword', 'Forgot Password ?'),
          const SizedBox(height: 34.0),
          TextField(
            autofocus: true,
            autocorrect: false,
            controller: _controller,
            textAlign: TextAlign.center,
            decoration: kTextFieldDecoration(
              isHidden: null,
              togglePasswordView: null,
            ),
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24.0),
          Hero(
            tag: 'login',
            child: RoundedButton(
              color: Colors.transparent,
              text: 'Send',
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  final email = _controller.text.trim();
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                } else {
                  final snackBar = ksnackBar('All fields are not populated !');
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } //all fields are not populated
              },
            ),
          ),
          const SizedBox(height: 24.0),
          Hero(
            tag: 'forgotPassword',
            child: GestureDetector(
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
          ),
        ],
      ),
    );
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetSentDialog(context);
          }
          if (state.exception is UserNotFound) {
            showErrorDialogue(
                context, 'Please make sure you are registered user');
          } else if (state.exception is InvalidEmail) {
            showErrorDialogue(
                context, 'Please make sure your email is correct');
          } else if (state.exception is AnyOtherException) {
            showErrorDialogue(context, 'Authentication Error');
          }
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: MediaQuery.of(context).size.width >= 400
              ? padding
              : SingleChildScrollView(child: padding),
        ),
      ),
    );
  }
}

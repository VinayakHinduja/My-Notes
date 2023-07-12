// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dialogue/error_dialogue.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/bloc/auth_bloc.dart';
import '../../services/bloc/auth_event.dart';
import '../../services/bloc/auth_state.dart';
import '../../widgets/constants.dart';
import '../../widgets/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    final padding = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          klogo(), // logo
          const SizedBox(height: 25.0),
          kHero('welcome', 'My Notes'),
          const SizedBox(height: 48.0),
          TextField(
            onChanged: (value) => email = value,
            autocorrect: false,
            textAlign: TextAlign.center,
            decoration: kTextFieldDecoration,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
          ), // email field
          const SizedBox(height: 12.0),
          TextField(
            obscureText: _isHidden,
            autocorrect: false,
            enableSuggestions: false,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.visiblePassword,
            onChanged: (value) => password = value,
            decoration: kTextFieldDecoration.copyWith(
                hintText: 'Enter your password',
                suffix: kSuffix(_isHidden, () => _togglePasswordView())),
          ), // password field
          const SizedBox(height: 10.0),
          Hero(
            tag: 'forgotPassword',
            child: GestureDetector(
              onTap: () =>
                  context.read<AuthBloc>().add(const AuthEventForgotPassword()),
              child: const Text(
                'Forgot Password ?',
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ), // forgot password
          const SizedBox(height: 24.0),
          Hero(
            tag: 'login',
            child: RoundedButton(
              text: 'Log In',
              color: Colors.transparent,
              onPressed: () async {
                if (email != null && password != null) {
                  context
                      .read<AuthBloc>()
                      .add(AuthEventLogIn(email!, password!));
                } else {
                  final snackBar = ksnackBar('All fields are not populated');
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
          ), // login button
          const SizedBox(height: 30),
          Hero(
            tag: 'member',
            child: GestureDetector(
              onTap: () =>
                  context.read<AuthBloc>().add(const AuthEventShouldRegister()),
              child: const Text(
                'Not a member ? Register Now',
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
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFound) {
            showErrorDialogue(
                context, 'Cannot find the user with entered Credentials');
          } else if (state.exception is WrongPassword) {
            showErrorDialogue(context, 'Wrong Credentials !!');
          } else if (state.exception is UserDisabled) {
            showErrorDialogue(
                context,
                'The account through which you are trying '
                'to login has been disable.');
          } else if (state.exception is TooManyRequests) {
            showErrorDialogue(
                context,
                'Multiple Login attempts have been detected'
                ' your account has been disabled for 5 minutes');
          } else if (state.exception is AnyOtherException) {
            showErrorDialogue(context, 'Authentication Error');
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: MediaQuery.of(context).size.width >= 400
            ? padding
            : SingleChildScrollView(child: padding),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dialogue/error_dialogue.dart';

import 'package:my_notes/services/bloc.dart';

import 'package:my_notes/widgets/widgets.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  String? email;
  String? name;
  String? password;
  String? password2;
  bool _isHidden = true;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPassword) {
            final snackBar = ksnackBar('Weak Password');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state.exception is EmailAlreadyInUse) {
            final snackBar = ksnackBar('Email as already in use');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state.exception is InvalidEmail) {
            final snackBar = ksnackBar('Email is invalid');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state.exception is UserNotFound) {
            final snackBar = ksnackBar('User not found');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state.exception is AnyOtherException) {
            showErrorDialogue(context, 'Failed to register');
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                klogo(), // logo
                const SizedBox(height: 25.0),
                kHero('welcome', 'Register Now'),
                const SizedBox(height: 48.0),
                TextField(
                  onChanged: (value) => email = value,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  autocorrect: false,
                  decoration: kTextFieldDecoration(
                    isHidden: null,
                    togglePasswordView: null,
                  ),
                ), // Email text field
                const SizedBox(height: 12.0),
                TextField(
                  onChanged: (value) => name = value,
                  keyboardType: TextInputType.name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  autocorrect: false,
                  decoration: kTextFieldDecoration(
                    isHidden: null,
                    togglePasswordView: null,
                  ).copyWith(hintText: 'Enter Your Username'),
                ), // Username text field
                const SizedBox(height: 12.0),
                TextField(
                  obscureText: _isHidden,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.next,
                  textAlign: TextAlign.center,
                  onChanged: (value) => password = value,
                  decoration: kTextFieldDecoration(
                    isHidden: _isHidden,
                    togglePasswordView: () => _togglePasswordView(),
                  ).copyWith(hintText: 'Enter your password'),
                ), // password text field
                const SizedBox(height: 12.0),
                TextField(
                  obscureText: _isHidden,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.done,
                  textAlign: TextAlign.center,
                  onChanged: (value) => password2 = value,
                  decoration: kTextFieldDecoration(
                    isHidden: _isHidden,
                    togglePasswordView: () => _togglePasswordView(),
                  ).copyWith(hintText: 'Confirm your password'),
                ), // password2 text field
                const SizedBox(height: 24.0),
                Hero(
                  tag: 'Register',
                  child: RoundedButton(
                    text: 'Register',
                    color: Colors.transparent,
                    onPressed: () async {
                      if (email != null &&
                          name != null &&
                          password != null &&
                          password2 != null) {
                        if (password == password2) {
                          context.read<AuthBloc>().add(AuthEventRegister(
                                email: email!,
                                pass: password!,
                                name: name!,
                              ));
                        } else {
                          final snackBar = ksnackBar(
                              'Your Password and Confirmation Password does not match');
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } // passwords fields don't match
                      } else {
                        final snackBar =
                            ksnackBar('All fields are not populated');
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } // all fields are not populated
                    },
                  ),
                ), // Register Button
                const SizedBox(height: 30),
                Hero(
                  tag: 'member',
                  child: GestureDetector(
                    onTap: () =>
                        context.read<AuthBloc>().add(const AuthEventLogOut()),
                    child: const Text(
                      'Already a member  ?  Log In Now',
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
          ),
        ),
      ),
    );
  }
}

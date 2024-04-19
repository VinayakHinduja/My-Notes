// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_notes/services/bloc.dart';

import 'package:my_notes/widgets/widgets.dart';

import 'package:my_notes/dialogue/dialogue.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  UpdatePasswordScreenState createState() => UpdatePasswordScreenState();
}

class UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  String? oldPassword;
  String? newPassword;
  String? newPassword2;
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
          klogo(),
          const SizedBox(height: 48.0),
          kDefaultText('Update Password'),
          const SizedBox(height: 34.0),
          kTextField(
            kTextFieldDecoration(
              isHidden: _isHidden,
              togglePasswordView: () => _togglePasswordView(),
            ).copyWith(hintText: 'Enter old password'),
            _isHidden,
            (v) => oldPassword = v,
          ),
          const SizedBox(height: 12.0),
          kTextField(
            kTextFieldDecoration(
              isHidden: _isHidden,
              togglePasswordView: () => _togglePasswordView(),
            ).copyWith(hintText: 'Enter new password'),
            _isHidden,
            (v) => newPassword = v,
          ),
          const SizedBox(height: 12.0),
          kTextField(
            kTextFieldDecoration(
              isHidden: _isHidden,
              togglePasswordView: () => _togglePasswordView(),
            ).copyWith(hintText: 'Confirm new password'),
            _isHidden,
            (v) => newPassword2 = v,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 24.0),
          Hero(
            tag: 'Register',
            child: RoundedButton(
              color: Colors.transparent,
              text: 'Update',
              onPressed: () async {
                if (oldPassword != null &&
                    newPassword != null &&
                    newPassword2 != null) {
                  if (newPassword == newPassword2) {
                    context.read<AuthBloc>().add(AuthEventUpdatePassword(
                          newPass: newPassword,
                          oldPass: oldPassword,
                        ));
                  } else {
                    final snackBar = ksnackBar(
                        'Password and Confirmation Password does Not Match');
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } //password and conformation password does not match
                } else {
                  final snackBar = ksnackBar('All fields are not populated');
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } //all fields are not populated
              },
            ),
          ),
          const SizedBox(height: 24.0),
          GestureDetector(
            onTap: () =>
                context.read<AuthBloc>().add(const AuthEventSettings()),
            child: const Text(
              'Back',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateUpdatePassword) {
          if (state.exception is WeakPassword) {
            showErrorDialogue(context, 'Weak Password');
          }
          if (state.hasUpdated) {
            await showPasswordUpdateDialog(context);
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

// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dialogue/error_dialogue.dart';
import '../../dialogue/password_update_dialog.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/bloc/auth_bloc.dart';
import '../../services/bloc/auth_event.dart';
import '../../services/bloc/auth_state.dart';
import '../../widgets/constants.dart';
import '../../widgets/rounded_button.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({Key? key}) : super(key: key);

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
          TextField(
              autofocus: true,
              obscureText: _isHidden,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              onChanged: (value) {
                oldPassword = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter old password',
                  suffix: kSuffix(_isHidden, () => _togglePasswordView()))),
          const SizedBox(height: 12.0),
          TextField(
              obscureText: _isHidden,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              onChanged: (value) {
                newPassword = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter new password',
                  suffix: kSuffix(_isHidden, () => _togglePasswordView()))),
          const SizedBox(height: 12.0),
          TextField(
              obscureText: _isHidden,
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              onChanged: (value) {
                newPassword2 = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Confirm new password',
                  suffix: kSuffix(_isHidden, () => _togglePasswordView()))),
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
                          newPassword: newPassword,
                          oldPassword: oldPassword,
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
      child: WillPopScope(
        onWillPop: () => Future(() => false),
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

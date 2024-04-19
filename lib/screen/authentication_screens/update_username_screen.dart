// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_notes/services/bloc.dart';

import 'package:my_notes/widgets/widgets.dart';

import 'package:my_notes/dialogue/dialogue.dart';

class UpdateUsernameScreen extends StatefulWidget {
  const UpdateUsernameScreen({super.key});

  @override
  UpdateUsernameScreenState createState() => UpdateUsernameScreenState();
}

class UpdateUsernameScreenState extends State<UpdateUsernameScreen> {
  late final _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
          kDefaultText('Update Username'),
          const SizedBox(height: 34.0),
          TextField(
            autocorrect: false,
            controller: _controller,
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.center,
            decoration: kTextFieldDecoration(
              isHidden: null,
              togglePasswordView: null,
            ).copyWith(hintText: 'Enter your new Username'),
          ),
          const SizedBox(height: 24.0),
          Hero(
            tag: 'Register',
            child: RoundedButton(
              text: 'Update',
              color: Colors.transparent,
              onPressed: () async {
                if (_controller.text.isNotEmpty) {
                  try {
                    final newName = _controller.text;
                    context
                        .read<AuthBloc>()
                        .add(AuthEventUpdateUserName(newName: newName));
                    kFlutterToast('The Username has been Updated');
                  } catch (e) {
                    showErrorDialogue(context, e.runtimeType.toString());
                  }
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
        if (state is AuthStateUpdateUsername) {
          if (state.hasUpdated) {
            _controller.clear();
            await showUsernameUpdatedDialog(context);
          }
          if (state.exception != null) {
            showErrorDialogue(context, 'We could not update Your User Name');
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

// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:my_notes/services/bloc.dart';

import 'package:my_notes/widgets/widgets.dart';

import 'package:my_notes/dialogue/dialogue.dart';

import 'package:my_notes/screen/screens.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({super.key});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  AuthUser? loggedInUser;
  // String? pass;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    imageProvider();
  }

  void getCurrentUser() {
    try {
      final user = AuthService.firebase().currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      devtools.log('from get user in my account screen');
      devtools.log(e.runtimeType.toString());
    }
  }

  ImageProvider<Object> imageProvider() {
    if (loggedInUser!.user.photoURL != null) {
      return NetworkImage(loggedInUser!.user.photoURL!);
    } else {
      return const AssetImage('assets/images/project.png');
    }
  }

  @override
  Widget build(BuildContext context1) {
    // devtools.log(_isHidden.toString());
    return BlocListener<AuthBloc, AuthState>(
      listener: (context2, state) {
        if (state is AuthStateReAuthentication) {
          if (state.hasReAuthenticate) {
            final snackBar = ksnackBar('Old Password has been Authenticated');
            ScaffoldMessenger.of(context2).showSnackBar(snackBar);
          }
          if (state.exception is UserNotFound) {
            showErrorDialogue(
                context2, 'Cannot find the user with entered Credentials');
          } else if (state.exception is WrongPassword) {
            showErrorDialogue(context2, 'Wrong Credentials !!');
          } else if (state.exception is UserDisabled) {
            showErrorDialogue(
                context2,
                'The account through which you are trying '
                'to login has been disable.');
          } else if (state.exception is TooManyRequests) {
            showErrorDialogue(
                context2,
                'Multiple Login attempts have been detected'
                ' your account has been disabled for 5 minutes');
          } else if (state.exception is AnyOtherException) {
            showErrorDialogue(context2, 'Authentication Error');
          }
          if (state.exception != null) {
            context2.read<AuthBloc>().add(const AuthEventLoggedIn());
          }
        }
      },
      child: PopScope(
        canPop: false,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'My Account',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () =>
                  context1.read<AuthBloc>().add(const AuthEventLoggedIn()),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Hero(
                    transitionOnUserGestures: true,
                    tag: 'avatar',
                    child: SizedBox(
                      height: 225,
                      width: 225,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.lightBlue[50],
                            radius: 100,
                            foregroundImage: imageProvider(),
                          ),
                          Positioned(
                            bottom: 0,
                            right: -25,
                            child: RawMaterialButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  context: context1,
                                  builder: (context) =>
                                      const ProfilePopScreen(),
                                );
                              },
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                              shape: const CircleBorder(),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ), // circular avatar
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(2, 2), //(x,y)
                            blurRadius: 2,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Icon(
                                        Icons.person,
                                        size: 34,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Name ',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        loggedInUser!.displayName,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                height: 2,
                                width: double.infinity,
                                child: Container(color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Icon(
                                        Icons.email_outlined,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Email ',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      FittedBox(
                                        child: Text(
                                          loggedInUser!.email,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context1)
                                                        .size
                                                        .width >=
                                                    400
                                                ? 26
                                                : 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  kTemplate(
                    Icons.password_rounded,
                    'Update Password',
                    () => context1
                        .read<AuthBloc>()
                        .add(const AuthEventUpdatePassword()),
                  ), // password reset screen
                  const SizedBox(height: 25),
                  kTemplate(
                    Icons.verified_outlined,
                    'Verify Email',
                    () => loggedInUser!.isEmailVerifed
                        ? kFlutterToast('Your Email is already verified')
                        : context1
                            .read<AuthBloc>()
                            .add(const AuthEventSendEmailVerification()),
                  ), // verification screen
                  const SizedBox(height: 25),
                  kTemplate(
                    Icons.account_circle,
                    'Update Username',
                    () => context1
                        .read<AuthBloc>()
                        .add(const AuthEventUpdateUserName()),
                  ), //update username screen
                  const SizedBox(height: 25),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context3, state) {
                      if (state is AuthStateLoggedOut) {
                        if (state.exception != null) {
                          showErrorDialogue(context3, 'Authentication Error');
                          devtools.log(state.exception.toString());
                        }
                      }
                    },
                    child: kTemplate(
                      Icons.logout,
                      'Log out',
                      () async {
                        final shouldLogOut = await showLogOutDialogue(context1);
                        if (shouldLogOut) {
                          context1
                              .read<AuthBloc>()
                              .add(const AuthEventLogOut());
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context4, state) {
                      if (state is AuthStateLoggedOut) {
                        if (state.exception != null) {
                          showErrorDialogue(context4, 'Authentication Error');
                          devtools.log(state.exception.toString());
                        }
                      }
                    },
                    child: kTemplate(
                      Icons.delete,
                      'Delete Account',
                      () async {
                        final del = await showDeleteAccDialogue(context);
                        if (del) {
                          context.read<AuthBloc>().add(const AuthEventLogOut());
                          // Navigator.pop(context);
                          await AuthService.firebase().delete();
                          kFlutterToast('Your Account has been Deleted');
                        }
                      },
                    ),
                  ), // Delete Account
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

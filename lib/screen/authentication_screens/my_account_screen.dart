// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import '../../dialogue/error_dialogue.dart';
import '../../dialogue/logout_dialogue.dart';
import '../../services/auth/auth_exceptions.dart';
import '../../services/auth/auth_services.dart';
import '../../services/auth/auth_user.dart';
import '../../services/bloc/auth_bloc.dart';
import '../../services/bloc/auth_event.dart';
import '../../services/bloc/auth_state.dart';
import '../../widgets/constants.dart';
import 'profile_popup_screen.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_bloc/flutter_bloc.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({Key? key}) : super(key: key);

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  AuthUser? loggedInUser;
  String? password;
  bool _isHidden = false;

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

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
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateReAuthentication) {
          if (state.hasReAuthenticate) {
            final snackBar = ksnackBar('Old Password has been Authenticated');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
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
          if (state.exception != null) {
            context.read<AuthBloc>().add(const AuthEventLoggedIn());
          }
        }
      },
      child: WillPopScope(
        onWillPop: () => Future(() => false),
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
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLoggedIn());
                },
                icon: const Icon(Icons.arrow_back, color: Colors.black),
              )),
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
                              foregroundImage: imageProvider()),
                          Positioned(
                            bottom: 0,
                            right: -25,
                            child: RawMaterialButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    context: context,
                                    builder: (context) =>
                                        const ProfilePopScreen());
                              },
                              elevation: 2.0,
                              fillColor: Colors.white,
                              padding: const EdgeInsets.all(15.0),
                              shape: const CircleBorder(),
                              child: const Icon(Icons.camera_alt_outlined,
                                  color: Colors.black),
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
                            borderRadius: BorderRadius.circular(20)),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Row(children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Icon(Icons.person,
                                            size: 34, color: Colors.black))),
                                const SizedBox(width: 5),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Name ',
                                          style: TextStyle(color: Colors.grey)),
                                      Text(loggedInUser!.displayName,
                                          style: const TextStyle(
                                              fontSize: 30,
                                              color: Colors.black)),
                                    ]),
                              ]),
                              const SizedBox(height: 12),
                              SizedBox(
                                  height: 2,
                                  width: double.infinity,
                                  child: Container(color: Colors.grey)),
                              const SizedBox(height: 12),
                              Row(children: [
                                Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    child: const Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Icon(Icons.email_outlined,
                                            size: 34, color: Colors.black))),
                                const SizedBox(width: 5),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Email ',
                                          style: TextStyle(color: Colors.grey)),
                                      FittedBox(
                                        child: Text(
                                          loggedInUser!.email,
                                          style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width >=
                                                    400
                                                ? 30
                                                : 18,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ]),
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
                      () => context.read<AuthBloc>().add(
                          const AuthEventUpdatePassword())), // password reset screen
                  const SizedBox(height: 25),
                  kTemplate(
                      Icons.verified_outlined,
                      'Verify Email',
                      () => loggedInUser!.isEmailVerifed
                          ? kFlutterToast('Your Email is already verified')
                          : context.read<AuthBloc>().add(
                              const AuthEventSendEmailVerification())), // verification screen
                  const SizedBox(height: 25),
                  kTemplate(
                      Icons.account_circle,
                      'Update Username',
                      () => context.read<AuthBloc>().add(
                          const AuthEventUpdateUserName())), //update username screen
                  const SizedBox(height: 25),
                  kTemplate(
                    Icons.delete,
                    'Delete Account',
                    () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Center(
                                  child: Text('Delete Account !!',
                                      textAlign: TextAlign.center)),
                              titleTextStyle: const TextStyle(
                                  fontSize: 30,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              content: const Text(
                                  'Are you sure You want to Delete your Account ? '
                                  'Once Deleted your data cannot be retrieved no matter what !!',
                                  textAlign: TextAlign.center),
                              contentTextStyle: const TextStyle(
                                  fontSize: 25.0, color: Colors.grey),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: TextField(
                                      maxLines: 1,
                                      autofocus: true,
                                      cursorWidth: 1.5,
                                      cursorHeight: 20,
                                      autocorrect: false,
                                      obscureText: _isHidden,
                                      enableSuggestions: false,
                                      cursorColor: Colors.blueGrey,
                                      textAlign: TextAlign.center,
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      textInputAction: TextInputAction.done,
                                      decoration: kTextFieldDecoration.copyWith(
                                          hintText: 'Confirm Your Password',
                                          suffix: kSuffix(_isHidden,
                                              () => _togglePasswordView)),
                                      onChanged: (value) {
                                        password = value;
                                      }),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton(
                                          onPressed: () async {
                                            if (password!.isNotEmpty) {
                                              context.read<AuthBloc>().add(
                                                  AuthEventReAuthenticate(
                                                      password: password));
                                            } else {
                                              ksnackBar(
                                                  'Please enter the password');
                                            }
                                            await AuthService.firebase()
                                                .delete();
                                            kFlutterToast(
                                                'Your Account has been Deleted');
                                            context
                                                .read<AuthBloc>()
                                                .add(const AuthEventLogOut());
                                          },
                                          child: const Text('Yes',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.red,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      SizedBox(
                                          height: 20.0,
                                          width: 2.0,
                                          child: Container(color: Colors.grey)),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('No',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                    ]),
                                const SizedBox(height: 5),
                              ],
                            );
                          });
                    },
                  ), // Delete Account
                  const SizedBox(height: 25),
                  BlocListener<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthStateLoggedOut) {
                        if (state.exception != null) {
                          showErrorDialogue(context, 'Authentication Error');
                          devtools.log(state.exception.toString());
                        }
                      }
                    },
                    child: kTemplate(Icons.logout, 'Log out', () async {
                      final shouldLogOut = await showLogOutDialogue(context);
                      if (shouldLogOut) {
                        context.read<AuthBloc>().add(const AuthEventLogOut());
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

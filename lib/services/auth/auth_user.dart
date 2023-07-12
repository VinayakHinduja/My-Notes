import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

@immutable
class AuthUser {
  final bool isEmailVerifed;
  final String email;
  final String uid;
  final String displayName;
  final User user;

  const AuthUser({
    required this.user,
    required this.uid,
    required this.isEmailVerifed,
    required this.email,
    required this.displayName,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName!, //?? 'No user name is setted',
        isEmailVerifed: user.emailVerified,
        user: user,
      );
}

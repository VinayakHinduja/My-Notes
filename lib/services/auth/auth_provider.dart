import 'package:firebase_auth/firebase_auth.dart' show User;

import 'auth_user.dart';

abstract class AuthProvider {
  Future<AuthUser> logIn({
    required String email,
    required String password,
  });
  Future<User> createUser({
    required String email,
    required String password,
  });
  AuthUser? get currentUser;
  Future<void> logOut();
  Future<void> delete();
  Future<void> initialize();
  Future<void> updatePhotoUrl();
  Future<void> deletePhotoUrl();
  Future<void> sendEmailVerification();
  Future<void> updateEmail({required String newEmail});
  Future<void> updatePassword({required String newPassword});
  Future<void> sendPasswordResetEmail({required String email});
  Future<void> updateDisplayName({required String displayName});
  Future<void> reAuthenticateWithCredentials({required String password});
}

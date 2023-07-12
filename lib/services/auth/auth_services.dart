import 'package:firebase_auth/firebase_auth.dart' show User;

import 'auth_provider.dart';
import 'auth_user.dart';
import 'firebase_auth_provider.dart';
import 'dart:developer' as devtools show log;

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) async {
    devtools.log('create user called from provider');
    return await provider.createUser(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => provider.currentUser;

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    return await provider.logIn(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logOut() async => await provider.logOut();

  @override
  Future<void> sendEmailVerification() async =>
      await provider.sendEmailVerification();

  @override
  Future<void> initialize() async => await provider.initialize();

  @override
  Future<void> updateDisplayName({required String displayName}) async =>
      await provider.updateDisplayName(displayName: displayName);

  @override
  Future<void> updatePassword({required String newPassword}) async =>
      await provider.updatePassword(newPassword: newPassword);

  @override
  Future<void> sendPasswordResetEmail({required String email}) async =>
      await provider.sendPasswordResetEmail(email: email);

  @override
  Future<void> updateEmail({required String newEmail}) async =>
      await provider.updateEmail(newEmail: newEmail);

  @override
  Future<void> delete() async => await provider.delete();

  @override
  Future<void> updatePhotoUrl() async => await provider.updatePhotoUrl();

  @override
  Future<void> deletePhotoUrl() async => await provider.deletePhotoUrl();

  @override
  Future<void> reAuthenticateWithCredentials(
          {required String password}) async =>
      await provider.reAuthenticateWithCredentials(password: password);
}

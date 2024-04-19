// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:developer' as devtools show log;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show EmailAuthProvider, FirebaseAuth, FirebaseAuthException, User;
import 'package:image_picker/image_picker.dart';
import '../../firebase_options.dart';

import 'auth_user.dart';
import 'auth_provider.dart';
import 'auth_exceptions.dart';

class FirebaseAuthProvider implements AuthProvider {
  @override
  Future<User> createUser({
    required String email,
    required String password,
  }) async {
    try {
      devtools.log('create user called from firebase');
      final cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      devtools.log('created user called from firebase');
      final user = cred.user;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedIn();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPassword();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUse();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmail();
      } else if (e.code == 'user-not-found') {
        throw UserNotFound();
      } else {
        devtools.log(e.code);
        devtools.log(e.hashCode.toString());
        devtools.log(e.runtimeType.toString());
        devtools.log('from firebase auth create user e =  type');
        throw AnyOtherException(e);
      }
    } catch (e) {
      devtools.log(e.hashCode.toString());
      devtools.log(e.runtimeType.toString());
      devtools.log('from firebase auth create user e = object');
      throw AnyOtherException(e);
    }
  }

  @override
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedIn();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFound();
      } else if (e.code == 'wrong-password') {
        throw WrongPassword();
      } else if (e.code == 'user-disabled') {
        throw UserDisabled();
      } else if (e.code == 'too-many-requests') {
        throw TooManyRequests();
      } else {
        devtools.log(e.code);
        devtools.log(e.hashCode.toString());
        devtools.log(e.runtimeType.toString());
        devtools.log('from firebase auth login e =  type');
        throw AnyOtherException(e);
      }
    } catch (e) {
      devtools.log(e.hashCode.toString());
      devtools.log(e.runtimeType.toString());
      devtools.log('from firebase auth login e = object');
      throw AnyOtherException(e);
    }
  }

  @override
  Future<void> logOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (e) {
        throw AnyOtherException(e);
      }
    } else {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await user.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'too-many-requests') {
          throw TooManyRequests();
        } else {
          devtools.log(e.code);
        }
      }
    } else {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  @override
  Future<void> updateDisplayName({required String displayName}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
    } else {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> updatePassword({required String newPassword}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updatePassword(newPassword);
    } else {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'firebase_auth/invalid-email':
          throw InvalidEmail();
        case 'firebase_auth/user-not-found':
          throw UserNotFound();
        default:
          throw AnyOtherException(e);
      }
    } catch (e) {
      throw AnyOtherException(e);
    }
  }

  @override
  Future<void> updateEmail({required String newEmail}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.verifyBeforeUpdateEmail(newEmail);
    } else {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> delete() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.delete();
    } else {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> updatePhotoUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        Reference ref =
            FirebaseStorage.instance.ref().child('${user.uid} ${user.email}');
        await ref.putFile(File(image!.path));
        ref.getDownloadURL().then((value) async {
          await user.updatePhotoURL(value);
        });
      } catch (e) {
        devtools.log('from firebase update profile pic');
        devtools.log(e.hashCode.toString());
        devtools.log(e.runtimeType.toString());
      }
    } else {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> deletePhotoUrl() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updatePhotoURL(null);
    } else {
      throw UserNotLoggedIn();
    }
  }

  @override
  Future<void> reAuthenticateWithCredentials({required String password}) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred =
        EmailAuthProvider.credential(email: user!.email!, password: password);
    if (user != null) {
      try {
        await user.reauthenticateWithCredential(cred);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          throw UserNotFound();
        } else if (e.code == 'wrong-password') {
          throw WrongPassword();
        } else if (e.code == 'user-disabled') {
          throw UserDisabled();
        } else if (e.code == 'too-many-requests') {
          throw TooManyRequests();
        } else {
          devtools.log(e.code);
          devtools.log(e.hashCode.toString());
          devtools.log(e.runtimeType.toString());
          devtools.log('from firebase auth re-authentication e =  type');
          throw AnyOtherException(e);
        }
      } catch (e) {
        devtools.log(e.hashCode.toString());
        devtools.log(e.runtimeType.toString());
        devtools.log('from firebase auth re-authentication e =  object');
        throw AnyOtherException(e);
      }
    } else {
      throw UserNotLoggedIn();
    }
  }
}

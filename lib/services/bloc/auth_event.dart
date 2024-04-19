import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventInitialize extends AuthEvent {
  const AuthEventInitialize();
}

class AuthEventSendEmailVerification extends AuthEvent {
  const AuthEventSendEmailVerification();
}

class AuthEventLogIn extends AuthEvent {
  final String email;
  final String pass;
  const AuthEventLogIn(this.email, this.pass);
}

class AuthEventLoggedIn extends AuthEvent {
  const AuthEventLoggedIn();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String pass;
  final String name;

  const AuthEventRegister({
    required this.email,
    required this.pass,
    required this.name,
  });
}

class AuthEventShouldRegister extends AuthEvent {
  const AuthEventShouldRegister();
}

class AuthEventLogOut extends AuthEvent {
  const AuthEventLogOut();
}

class AuthEventUpdateUserName extends AuthEvent {
  final String? newName;
  const AuthEventUpdateUserName({this.newName});
}

class AuthEventUpdatePassword extends AuthEvent {
  final String? oldPass;
  final String? newPass;
  const AuthEventUpdatePassword({this.newPass, this.oldPass});
}

class AuthEventReAuthenticate extends AuthEvent {
  final String? pass;
  const AuthEventReAuthenticate({this.pass});
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

class AuthEventSettings extends AuthEvent {
  const AuthEventSettings();
}

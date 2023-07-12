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
  final String password;
  const AuthEventLogIn(this.email, this.password);
}

class AuthEventLoggedIn extends AuthEvent {
  const AuthEventLoggedIn();
}

class AuthEventRegister extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthEventRegister({
    required this.email,
    required this.password,
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
  final String? oldPassword;
  final String? newPassword;
  const AuthEventUpdatePassword({this.newPassword, this.oldPassword});
}

class AuthEventReAuthenticate extends AuthEvent {
  final String? password;
  const AuthEventReAuthenticate({this.password});
}

class AuthEventForgotPassword extends AuthEvent {
  final String? email;
  const AuthEventForgotPassword({this.email});
}

class AuthEventSettings extends AuthEvent {
  const AuthEventSettings();
}

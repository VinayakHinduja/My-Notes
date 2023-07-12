// login exceptions
class UserNotFound implements Exception {}

class WrongPassword implements Exception {}

class UserDisabled implements Exception {}

class TooManyRequests implements Exception {}

// registration exceptions
class WeakPassword implements Exception {}

class EmailAlreadyInUse implements Exception {}

class InvalidEmail implements Exception {}

// generic exception
class UserNotLoggedIn implements Exception {}

class AnyOtherException implements Exception {
  late Object e;
  AnyOtherException(this.e);
}

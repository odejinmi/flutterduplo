import 'my_strings.dart';

class DuploException implements Exception {
  String? message;

  DuploException(this.message);

  @override
  String toString() {
    if (message == null) return Strings.unKnownError;
    return message!;
  }
}

class AuthenticationException extends DuploException {
  AuthenticationException(String message) : super(message);
}

class CardException extends DuploException {
  CardException(String message) : super(message);
}

class ChargeException extends DuploException {
  ChargeException(String? message) : super(message);
}

class InvalidAmountException extends DuploException {
  int amount = 0;

  InvalidAmountException(this.amount)
      : super('$amount is not a valid '
            'amount. only positive non-zero values are allowed.');
}

class InvalidEmailException extends DuploException {
  String? email;

  InvalidEmailException(this.email) : super('$email  is not a valid email');
}

class DuploSdkNotInitializedException extends DuploException {
  DuploSdkNotInitializedException(String message) : super(message);
}

class ProcessingException extends ChargeException {
  ProcessingException()
      : super(
            'A transaction is currently processing, please wait till it concludes before attempting a  charge.');
}

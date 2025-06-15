// Exceções específicas para o login.

class LoginValidationFailure implements Exception {
  final String message;
  LoginValidationFailure(this.message);
}

class LoginFailure implements Exception {
  final String message;
  final String? type;
  LoginFailure(this.message, [this.type]);
}

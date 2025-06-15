// Exceções específicas para o cadastro.

class CadastroValidationFailure implements Exception {
  final String message;
  CadastroValidationFailure(this.message);
}

class CadastroFailure implements Exception {
  final String message;
  CadastroFailure(this.message);
}

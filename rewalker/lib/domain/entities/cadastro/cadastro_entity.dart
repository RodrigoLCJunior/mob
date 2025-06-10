class CadastroEntity {
  final String nome;
  final String email;
  final String senha;
  final String confirmaSenha;

  final String? nomeError;
  final String? emailError;
  final String? senhaError;
  final String? confirmaSenhaError;

  final bool isLoading;
  final bool success;
  final String? errorMessage;

  const CadastroEntity({
    this.nome = '',
    this.email = '',
    this.senha = '',
    this.confirmaSenha = '',
    this.nomeError,
    this.emailError,
    this.senhaError,
    this.confirmaSenhaError,
    this.isLoading = false,
    this.success = false,
    this.errorMessage,
  });

  CadastroEntity copyWith({
    String? nome,
    String? email,
    String? senha,
    String? confirmaSenha,
    String? nomeError,
    String? emailError,
    String? senhaError,
    String? confirmaSenhaError,
    bool? isLoading,
    bool? success,
    String? errorMessage,
  }) {
    return CadastroEntity(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      confirmaSenha: confirmaSenha ?? this.confirmaSenha,
      nomeError: nomeError,
      emailError: emailError,
      senhaError: senhaError,
      confirmaSenhaError: confirmaSenhaError,
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      errorMessage: errorMessage,
    );
  }
}

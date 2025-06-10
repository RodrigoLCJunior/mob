class LoginEntity {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final bool isLoading;
  final bool success;
  final String? errorMessage;

  LoginEntity({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.isLoading = false,
    this.success = false,
    this.errorMessage,
  });

  LoginEntity copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    bool? isLoading,
    bool? success,
    String? errorMessage,
  }) {
    return LoginEntity(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      isLoading: isLoading ?? this.isLoading,
      success: success ?? this.success,
      errorMessage: errorMessage,
    );
  }
}

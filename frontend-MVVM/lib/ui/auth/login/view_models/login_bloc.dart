/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components do login
 ** Obs...:
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';

// Eventos
abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  final String email;

  const LoginEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class LoginSubmitted extends LoginEvent {}

// Estado
class LoginState extends Equatable {
  final String email;
  final String password;
  final String? emailError;
  final String? passwordError;
  final String? generalError;
  final bool isLoading;
  final bool isLoginSuccess;

  const LoginState({
    this.email = '',
    this.password = '',
    this.emailError,
    this.passwordError,
    this.generalError,
    this.isLoading = false,
    this.isLoginSuccess = false,
  });

  LoginState copyWith({
    String? email,
    String? password,
    String? emailError,
    String? passwordError,
    String? generalError,
    bool? isLoading,
    bool? isLoginSuccess,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailError: emailError,
      passwordError: passwordError,
      generalError: generalError,
      isLoading: isLoading ?? this.isLoading,
      isLoginSuccess: isLoginSuccess ?? this.isLoginSuccess,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    emailError,
    passwordError,
    generalError,
    isLoading,
    isLoginSuccess,
  ];
}

// Bloc
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserService userService;

  LoginBloc({required this.userService}) : super(const LoginState()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    emit(
      state.copyWith(email: event.email, emailError: null, generalError: null),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        password: event.password,
        passwordError: null,
        generalError: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // Validação
    String? emailError;
    String? passwordError;

    if (state.email.isEmpty) {
      emailError = "O email não pode estar vazio";
    } else {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(state.email)) {
        emailError = "Digite um email válido";
      }
    }

    if (state.password.isEmpty) {
      passwordError = "A senha não pode estar vazia";
    } else if (state.password.length < 6) {
      passwordError = "A senha deve ter pelo menos 6 caracteres";
    }

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(emailError: emailError, passwordError: passwordError),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, generalError: null));

    try {
      final result = await userService.fazerLogin(
        state.email.trim(),
        state.password.trim(),
      );
      if (result["success"]) {
        emit(
          state.copyWith(
            isLoading: false,
            isLoginSuccess: true,
            generalError: null,
          ),
        );
      } else {
        String errorMessage = result["message"] ?? "Erro ao fazer login";
        if (result["error"] == "email" ||
            errorMessage.toLowerCase().contains("email")) {
          emit(state.copyWith(isLoading: false, emailError: errorMessage));
        } else if (result["error"] == "senha" ||
            errorMessage.toLowerCase().contains("senha")) {
          emit(state.copyWith(isLoading: false, passwordError: errorMessage));
        } else {
          emit(state.copyWith(isLoading: false, generalError: errorMessage));
        }
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          generalError: "Erro interno. Tente novamente mais tarde.",
        ),
      );
    }
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:midnight_never_end/data/datasources/user/usuario_datasource.dart';
import 'package:midnight_never_end/core/error/exceptions.dart';
import 'package:midnight_never_end/domain/entities/login/login_entity.dart';

class LoginViewModel extends Cubit<LoginEntity> {
  final UsuarioDataSource usuarioDataSource;

  LoginViewModel({required this.usuarioDataSource}) : super(LoginEntity());

  void updateEmail(String email) {
    emit(
      state.copyWith(
        email: email,
        emailError: null,
        success: false,
        errorMessage: null,
      ),
    );
  }

  void updatePassword(String password) {
    emit(
      state.copyWith(
        password: password,
        passwordError: null,
        success: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> login() async {
    emit(state.copyWith(isLoading: true, success: false, errorMessage: null));

    final emailError = _validateEmail(state.email);
    final passwordError = _validatePassword(state.password);
    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          isLoading: false,
          success: false,
        ),
      );
      return;
    }

    try {
      // Adiciona timeout de 30 segundos
      final usuario = await usuarioDataSource
          .fazerLogin(state.email, state.password)
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () {
              throw TimeoutException(
                'O login demorou demais para ser processado',
              );
            },
          );

      await usuarioDataSource.saveUsuario(usuario);
      emit(
        state.copyWith(
          isLoading: false,
          success: true,
          errorMessage: null,
          emailError: null,
          passwordError: null,
        ),
      );
    } catch (e) {
      String? emailError;
      String? passwordError;
      String errorMessage;
      if (e is ServerException) {
        if (e.message.toLowerCase().contains('email')) {
          emailError = e.message;
        } else if (e.message.toLowerCase().contains('senha')) {
          passwordError = e.message;
        }
        errorMessage = e.message;
      } else if (e is TimeoutException) {
        errorMessage = 'Tempo de login excedido. Tente novamente.';
      } else {
        errorMessage = 'Erro desconhecido ao fazer login';
      }
      emit(
        state.copyWith(
          emailError: emailError,
          passwordError: passwordError,
          isLoading: false,
          success: false,
          errorMessage: errorMessage,
        ),
      );
    }
  }

  Future<void> openCadastro() async {
    emit(state.copyWith(isLoading: true, success: false));
    emit(state.copyWith(isLoading: false, success: false));
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'O email não pode estar vazio';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) return 'Digite um email válido';
    return null;
  }

  String? _validatePassword(String password) {
    if (password.isEmpty) return 'A senha não pode estar vazia';
    if (password.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
    return null;
  }
}

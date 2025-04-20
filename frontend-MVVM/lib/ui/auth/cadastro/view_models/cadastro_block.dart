/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components do cadastro
 ** Obs...:
 */

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';

// Eventos
abstract class CadastroEvent extends Equatable {
  const CadastroEvent();

  @override
  List<Object?> get props => [];
}

class CadastroNomeChanged extends CadastroEvent {
  final String nome;

  const CadastroNomeChanged(this.nome);

  @override
  List<Object?> get props => [nome];
}

class CadastroEmailChanged extends CadastroEvent {
  final String email;

  const CadastroEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class CadastroSenhaChanged extends CadastroEvent {
  final String senha;

  const CadastroSenhaChanged(this.senha);

  @override
  List<Object?> get props => [senha];
}

class CadastroConfirmaSenhaChanged extends CadastroEvent {
  final String confirmaSenha;

  const CadastroConfirmaSenhaChanged(this.confirmaSenha);

  @override
  List<Object?> get props => [confirmaSenha];
}

class CadastroSubmitted extends CadastroEvent {}

// Estado
class CadastroState extends Equatable {
  final String nome;
  final String email;
  final String senha;
  final String confirmaSenha;
  final String? nomeError;
  final String? emailError;
  final String? senhaError;
  final String? confirmaSenhaError;
  final String? generalError;
  final bool isLoading;
  final bool isCadastroSuccess;

  const CadastroState({
    this.nome = '',
    this.email = '',
    this.senha = '',
    this.confirmaSenha = '',
    this.nomeError,
    this.emailError,
    this.senhaError,
    this.confirmaSenhaError,
    this.generalError,
    this.isLoading = false,
    this.isCadastroSuccess = false,
  });

  CadastroState copyWith({
    String? nome,
    String? email,
    String? senha,
    String? confirmaSenha,
    String? nomeError,
    String? emailError,
    String? senhaError,
    String? confirmaSenhaError,
    String? generalError,
    bool? isLoading,
    bool? isCadastroSuccess,
  }) {
    return CadastroState(
      nome: nome ?? this.nome,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      confirmaSenha: confirmaSenha ?? this.confirmaSenha,
      nomeError: nomeError,
      emailError: emailError,
      senhaError: senhaError,
      confirmaSenhaError: confirmaSenhaError,
      generalError: generalError,
      isLoading: isLoading ?? this.isLoading,
      isCadastroSuccess: isCadastroSuccess ?? this.isCadastroSuccess,
    );
  }

  @override
  List<Object?> get props => [
    nome,
    email,
    senha,
    confirmaSenha,
    nomeError,
    emailError,
    senhaError,
    confirmaSenhaError,
    generalError,
    isLoading,
    isCadastroSuccess,
  ];
}

// Bloc
class CadastroBloc extends Bloc<CadastroEvent, CadastroState> {
  final UserService userService;

  CadastroBloc({required this.userService}) : super(const CadastroState()) {
    on<CadastroNomeChanged>(_onNomeChanged);
    on<CadastroEmailChanged>(_onEmailChanged);
    on<CadastroSenhaChanged>(_onSenhaChanged);
    on<CadastroConfirmaSenhaChanged>(_onConfirmaSenhaChanged);
    on<CadastroSubmitted>(_onSubmitted);
  }

  void _onNomeChanged(CadastroNomeChanged event, Emitter<CadastroState> emit) {
    emit(state.copyWith(nome: event.nome, nomeError: null, generalError: null));
  }

  void _onEmailChanged(
    CadastroEmailChanged event,
    Emitter<CadastroState> emit,
  ) {
    emit(
      state.copyWith(email: event.email, emailError: null, generalError: null),
    );
  }

  void _onSenhaChanged(
    CadastroSenhaChanged event,
    Emitter<CadastroState> emit,
  ) {
    emit(
      state.copyWith(senha: event.senha, senhaError: null, generalError: null),
    );
  }

  void _onConfirmaSenhaChanged(
    CadastroConfirmaSenhaChanged event,
    Emitter<CadastroState> emit,
  ) {
    emit(
      state.copyWith(
        confirmaSenha: event.confirmaSenha,
        confirmaSenhaError: null,
        generalError: null,
      ),
    );
  }

  Future<void> _onSubmitted(
    CadastroSubmitted event,
    Emitter<CadastroState> emit,
  ) async {
    // Validação
    String? nomeError;
    String? emailError;
    String? senhaError;
    String? confirmaSenhaError;

    if (state.nome.isEmpty) {
      nomeError = "O nome não pode estar vazio";
    }

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

    if (state.senha.isEmpty) {
      senhaError = "A senha não pode estar vazia";
    } else if (state.senha.length < 6) {
      senhaError = "A senha deve ter pelo menos 6 caracteres";
    }

    if (state.confirmaSenha.isEmpty) {
      confirmaSenhaError = "A confirmação de senha não pode estar vazia";
    } else if (state.confirmaSenha != state.senha) {
      confirmaSenhaError = "As senhas não coincidem";
    }

    if (nomeError != null ||
        emailError != null ||
        senhaError != null ||
        confirmaSenhaError != null) {
      emit(
        state.copyWith(
          nomeError: nomeError,
          emailError: emailError,
          senhaError: senhaError,
          confirmaSenhaError: confirmaSenhaError,
        ),
      );
      return;
    }

    emit(state.copyWith(isLoading: true, generalError: null));

    try {
      final cadastroResult = await userService.criarUsuario(
        state.nome.trim(),
        state.email.trim(),
        state.senha.trim(),
      );

      if (cadastroResult["success"]) {
        // Cadastro bem-sucedido, agora faz o login automático
        final loginResult = await userService.fazerLogin(
          state.email.trim(),
          state.senha.trim(),
        );

        if (loginResult["success"]) {
          emit(
            state.copyWith(
              isLoading: false,
              isCadastroSuccess: true,
              generalError: null,
            ),
          );
        } else {
          String errorMessage =
              loginResult["message"] ?? "Erro ao fazer login após cadastro";
          emit(state.copyWith(isLoading: false, generalError: errorMessage));
        }
      } else {
        String errorMessage = cadastroResult["message"] ?? "Erro ao cadastrar";
        if (errorMessage.toLowerCase().contains("email")) {
          emit(state.copyWith(isLoading: false, emailError: errorMessage));
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

/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components do User
 ** Obs...:
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:midnight_never_end/core/service/user/user_service.dart'
    show UserService;
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';

// Eventos
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserEvent extends UserEvent {}

class LoginEvent extends UserEvent {
  final String email;
  final String password;

  const LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class RegisterEvent extends UserEvent {
  final String nome;
  final String email;
  final String password;

  const RegisterEvent(this.nome, this.email, this.password);

  @override
  List<Object?> get props => [nome, email, password];
}

class UpdateUserCoinsEvent extends UserEvent {
  final int newCoins;

  const UpdateUserCoinsEvent(this.newCoins);

  @override
  List<Object?> get props => [newCoins];
}

class LogoutEvent extends UserEvent {}

// Estado
class UserState extends Equatable {
  final bool isLoading;
  final User? user;
  final String? message;

  const UserState({this.isLoading = false, this.user, this.message});

  UserState copyWith({bool? isLoading, User? user, String? message}) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [isLoading, user, message];
}

// Bloc (ViewModel)
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserService userService;

  UserBloc({required this.userService}) : super(const UserState()) {
    on<LoadUserEvent>(_onLoadUser);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<UpdateUserCoinsEvent>(_onUpdateUserCoins);
    on<LogoutEvent>(_onLogout);

    // Carregar usuário ao inicializar
    add(LoadUserEvent());
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, message: null));
    try {
      // O UserService já carrega o usuário no construtor, então apenas usamos o getter
      emit(
        state.copyWith(
          isLoading: false,
          user: userService.currentUser,
          message: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          user: null,
          message: "Erro ao carregar usuário: $e",
        ),
      );
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, message: null));
    final result = await userService.login(event.email, event.password);
    if (result["success"] == true) {
      emit(
        state.copyWith(
          isLoading: false,
          user: result["user"] as User,
          message: "Login realizado com sucesso",
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          user: null,
          message: result["message"]?.toString() ?? "Erro ao fazer login",
        ),
      );
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, message: null));
    final result = await userService.register(
      event.nome,
      event.email,
      event.password,
    );
    if (result["success"] == true) {
      emit(
        state.copyWith(
          isLoading: false,
          message:
              result["message"]?.toString() ?? "Cadastro realizado com sucesso",
        ),
      );
      // Após o cadastro, faz login automaticamente
      add(LoginEvent(event.email, event.password));
    } else {
      emit(
        state.copyWith(
          isLoading: false,
          message: result["message"]?.toString() ?? "Erro ao cadastrar",
        ),
      );
    }
  }

  Future<void> _onUpdateUserCoins(
    UpdateUserCoinsEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, message: null));
    try {
      await userService.updateUserCoins(event.newCoins);
      emit(
        state.copyWith(
          isLoading: false,
          user: userService.currentUser,
          message: "Moedas atualizadas com sucesso",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          message: "Erro ao atualizar moedas: $e",
        ),
      );
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoading: true, message: null));
    try {
      await userService.clearUser();
      emit(
        state.copyWith(
          isLoading: false,
          user: null,
          message: "Logout realizado com sucesso",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, message: "Erro ao fazer logout: $e"),
      );
    }
  }
}

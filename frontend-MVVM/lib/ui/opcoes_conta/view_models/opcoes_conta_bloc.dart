/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components do opcoes de conta
 ** Obs...:
 */

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Eventos
abstract class AccountOptionsEvent extends Equatable {
  const AccountOptionsEvent();

  @override
  List<Object?> get props => [];
}

class InitializeEvent extends AccountOptionsEvent {
  final String userName;

  const InitializeEvent(this.userName);

  @override
  List<Object?> get props => [userName];
}

class LogoutEvent extends AccountOptionsEvent {}

// Estado
class AccountOptionsState extends Equatable {
  final String userName;
  final bool isLoading;
  final bool isLogoutSuccess;
  final String? errorMessage;

  const AccountOptionsState({
    this.userName = "Usuário",
    this.isLoading = false,
    this.isLogoutSuccess = false,
    this.errorMessage,
  });

  AccountOptionsState copyWith({
    String? userName,
    bool? isLoading,
    bool? isLogoutSuccess,
    String? errorMessage,
  }) {
    return AccountOptionsState(
      userName: userName ?? this.userName,
      isLoading: isLoading ?? this.isLoading,
      isLogoutSuccess: isLogoutSuccess ?? this.isLogoutSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    userName,
    isLoading,
    isLogoutSuccess,
    errorMessage,
  ];
}

// Bloc
class AccountOptionsBloc
    extends Bloc<AccountOptionsEvent, AccountOptionsState> {
  AccountOptionsBloc() : super(const AccountOptionsState()) {
    on<InitializeEvent>(_onInitialize);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<AccountOptionsState> emit,
  ) async {
    emit(state.copyWith(userName: event.userName));
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AccountOptionsState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      UserManager.currentUser = null;

      emit(
        state.copyWith(
          isLoading: false,
          isLogoutSuccess: true,
          errorMessage: "Logout realizado com sucesso",
        ),
      );

      if (kDebugMode) print("Logout realizado com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode) print("Erro ao fazer logout: $e\n$stackTrace");
      emit(
        state.copyWith(
          isLoading: false,
          isLogoutSuccess: false,
          errorMessage: "Erro ao fazer logout. Tente novamente.",
        ),
      );
    }
  }
}

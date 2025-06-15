import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/data/repositories/user/usuario_repository.dart';
import 'package:midnight_never_end/domain/entities/core/request_state_entity.dart';
import 'package:midnight_never_end/domain/entities/opcoes/opcoes_entiry.dart';
import 'package:midnight_never_end/domain/error/core/opcoes_conta_exception.dart';
import 'package:midnight_never_end/data/repositories/user/usuario_repository_factory.dart';
import 'package:midnight_never_end/ui/intro/pages/intro_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountOptionsViewModel extends Cubit<IRequestState<String>> {
  late final UserRepository _userRepository;
  AccountOptionsEntity _entity = AccountOptionsEntity();

  AccountOptionsViewModel({required String? userName})
    : super(const RequestInitiationState()) {
    _entity = AccountOptionsEntity(userName: userName);
    _initialize();
  }

  Future<void> _initialize() async {
    _userRepository = await UserRepositoryFactory.create();
  }

  AccountOptionsEntity get entity => _entity;

  Future<void> logout(BuildContext context) async {
    try {
      _emitter(const RequestProcessingState(value: "Realizando logout..."));
      _entity = _entity.copyWith(isLoading: true);

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await _userRepository.logout();

      _entity = _entity.copyWith(isLoading: false);
      _emitter(
        const RequestCompletedState(value: "Logout realizado com sucesso"),
      );

      // Redireciona para a IntroScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
      );
    } catch (e) {
      _entity = _entity.copyWith(isLoading: false);
      final errorMessage = _createErrorDescription(e);
      _emitter(RequestErrorState(error: e, value: errorMessage));
    }
  }

  String _createErrorDescription(Object? error) {
    if (error is AccountException) return error.message;
    return 'Erro ao fazer logout. Tente novamente.';
  }

  void _emitter(IRequestState<String> state) {
    if (isClosed) return;
    emit(state);
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

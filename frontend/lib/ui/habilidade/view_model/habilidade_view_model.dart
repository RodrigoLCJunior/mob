import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/data/repositories/user/usuario_repository.dart';
import 'package:midnight_never_end/data/repositories/user/usuario_repository_factory.dart';
import 'package:midnight_never_end/domain/entities/core/request_state_entity.dart';
import 'package:midnight_never_end/domain/entities/habilidades/habilidades_entity.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';
import 'package:midnight_never_end/domain/error/core/habilidade_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabilidadesViewModel extends Cubit<IRequestState<String>> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  late final UserRepository _userRepository; // Alterado para late
  HabilidadeEntity _entity = HabilidadeEntity();
  bool _resourcesPreloaded = false;

  HabilidadesViewModel() : super(const RequestInitiationState()) {
    _initialize();
  }

  HabilidadeEntity get entity => _entity;

  Future<void> _initialize() async {
    try {
      _emitter(const RequestProcessingState(value: "Inicializando..."));
      // Inicializa o UserRepository usando a fábrica
      _userRepository = await UserRepositoryFactory.create();
      await _loadUser();
      await _loadData();
      _emitter(const RequestCompletedState(value: "Inicialização concluída"));
    } catch (error) {
      final errorDescription = _createErrorDescription(error);
      _emitter(RequestErrorState(error: error, value: errorDescription));
    }
  }

  Future<void> preloadResources(BuildContext context) async {
    if (_resourcesPreloaded) return;
    try {
      _emitter(
        const RequestProcessingState(value: "Pré-carregando recursos..."),
      );
      await precacheImage(
        const AssetImage("assets/icons/permCoin.png"),
        context,
      );
      await _audioPlayer.setVolume(0.5);
      await _audioPlayer.setSource(AssetSource('audios/ka-chin.mp3'));
      _resourcesPreloaded = true;
      _emitter(const RequestCompletedState(value: "Recursos pré-carregados"));
    } catch (e) {
      throw ResourcePreloadFailure('$e');
    }
  }

  Future<void> _loadUser() async {
    try {
      final usuario = await _userRepository.carregarUsuario();
      _updateEntity(userName: usuario?.nome ?? 'Conta');
    } catch (e) {
      throw DataLoadFailure('Erro ao carregar usuário: $e');
    }
  }

  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuario = await _userRepository.carregarUsuario();
      if (usuario == null) {
        throw DataLoadFailure('Usuário não encontrado');
      }

      int userCoins = usuario.moedaPermanente?.quantidade ?? 0;
      int savedInitialCoins =
          prefs.getInt('initial_coins_${usuario.id}') ?? userCoins;

      _updateEntity(
        coins: userCoins,
        initialCoins: savedInitialCoins,
        talents: _initializeTalents(prefs, usuario.id),
      );

      await prefs.setInt('initial_coins_${usuario.id}', savedInitialCoins);
    } catch (e) {
      throw DataLoadFailure('$e');
    }
  }

  List<Map<String, dynamic>> _initializeTalents(
    SharedPreferences prefs,
    String userId,
  ) {
    return [
      {
        "title": "Dano de Ataque",
        "icon": Icons.gavel,
        "level": prefs.getInt('talent_0_$userId') ?? 1,
        "cost": 10,
      },
      {
        "title": "Dano de Crítico",
        "icon": Icons.bolt,
        "level": prefs.getInt('talent_1_$userId') ?? 1,
        "cost": 10,
      },
      {
        "title": "Defesa",
        "icon": Icons.shield,
        "level": prefs.getInt('talent_2_$userId') ?? 1,
        "cost": 10,
      },
      {
        "title": "Ganho de Moeda",
        "icon": Icons.attach_money,
        "level": prefs.getInt('talent_3_$userId') ?? 1,
        "cost": 10,
      },
    ];
  }

  Future<void> upgradeTalent(int index) async {
    try {
      if (_entity.coins < _entity.talents[index]["cost"]) {
        throw HabilidadeException("Moedas insuficientes!");
      }

      _emitter(const RequestProcessingState(value: "Atualizando talento..."));
      await _playCoinSound();
      final updatedTalents = List<Map<String, dynamic>>.from(_entity.talents);
      updatedTalents[index]["level"] += 1;
      updatedTalents[index]["cost"] =
          (updatedTalents[index]["cost"] * 1.5).round();

      _updateEntity(
        coins: (_entity.coins - _entity.talents[index]["cost"]).toInt(),
        talents: updatedTalents,
      );

      await _saveData();
      _emitter(const RequestCompletedState(value: "Talento atualizado"));
    } catch (error) {
      final errorDescription = _createErrorDescription(error);
      _emitter(RequestErrorState(error: error, value: errorDescription));
    }
  }

  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usuario = await _userRepository.carregarUsuario();
      if (usuario == null) {
        throw DataSaveFailure('Usuário não encontrado');
      }

      usuario.copyWith(
        moedaPermanente:
            usuario.moedaPermanente?.copyWith(quantidade: _entity.coins) ??
            MoedaPermanente(id: "default", quantidade: _entity.coins),
      );
      await prefs.setInt('coins_${usuario.id}', _entity.coins);

      for (int i = 0; i < _entity.talents.length; i++) {
        await prefs.setInt(
          'talent_${i}_${usuario.id}',
          _entity.talents[i]["level"],
        );
      }
    } catch (e) {
      throw DataSaveFailure('$e');
    }
  }

  Future<void> _playCoinSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audios/ka-chin.mp3'));
    } catch (e) {
      throw AudioFailure('$e');
    }
  }

  String _createErrorDescription(Object? error) {
    if (error is ResourcePreloadFailure) return 'Erro ao pré-carregar recursos';
    if (error is DataLoadFailure) return 'Erro ao carregar dados';
    if (error is DataSaveFailure) return 'Erro ao salvar dados';
    if (error is AudioFailure) return 'Erro ao reproduzir áudio';
    return 'Erro desconhecido';
  }

  void _updateEntity({
    int? coins,
    int? initialCoins,
    List<Map<String, dynamic>>? talents,
    String? userName,
  }) {
    _entity = HabilidadeEntity(
      coins: coins ?? _entity.coins,
      initialCoins: initialCoins ?? _entity.initialCoins,
      talents: talents ?? _entity.talents,
      userName: userName ?? _entity.userName,
    );
  }

  void _emitter(IRequestState<String> state) {
    if (isClosed) return;
    emit(state);
  }

  @override
  Future<void> close() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    return super.close();
  }
}

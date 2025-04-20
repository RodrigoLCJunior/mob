/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components das habilidades
 ** Obs...:
 */

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';

// Eventos
abstract class HabilidadesEvent extends Equatable {
  const HabilidadesEvent();

  @override
  List<Object?> get props => [];
}

class InitializeEvent extends HabilidadesEvent {}

class EnableAudioEvent extends HabilidadesEvent {}

class UpgradeTalentEvent extends HabilidadesEvent {
  final int index;

  const UpgradeTalentEvent(this.index);

  @override
  List<Object?> get props => [index];
}

// Estado
class HabilidadesState extends Equatable {
  final int coins;
  final int initialCoins;
  final List<Map<String, dynamic>> talents;
  final bool isLoading;
  final bool isAudioEnabled;
  final bool showAudioPrompt;
  final String? errorMessage;

  const HabilidadesState({
    this.coins = 0,
    this.initialCoins = 0,
    this.talents = const [],
    this.isLoading = false,
    this.isAudioEnabled = false,
    this.showAudioPrompt = kIsWeb,
    this.errorMessage,
  });

  HabilidadesState copyWith({
    int? coins,
    int? initialCoins,
    List<Map<String, dynamic>>? talents,
    bool? isLoading,
    bool? isAudioEnabled,
    bool? showAudioPrompt,
    String? errorMessage,
  }) {
    return HabilidadesState(
      coins: coins ?? this.coins,
      initialCoins: initialCoins ?? this.initialCoins,
      talents: talents ?? this.talents,
      isLoading: isLoading ?? this.isLoading,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      showAudioPrompt: showAudioPrompt ?? this.showAudioPrompt,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    coins,
    initialCoins,
    talents,
    isLoading,
    isAudioEnabled,
    showAudioPrompt,
    errorMessage,
  ];
}

// Bloc
class HabilidadesBloc extends Bloc<HabilidadesEvent, HabilidadesState> {
  final AudioPlayer audioPlayer;
  final Logger logger;

  HabilidadesBloc({required this.audioPlayer})
    : logger = Logger(),
      super(const HabilidadesState()) {
    on<InitializeEvent>(_onInitialize);
    on<EnableAudioEvent>(_onEnableAudio);
    on<UpgradeTalentEvent>(_onUpgradeTalent);

    // Inicializar ao criar o Bloc
    add(InitializeEvent());
  }

  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<HabilidadesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final prefs = await SharedPreferences.getInstance();
      if (UserManager.currentUser == null) {
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: "Usuário não encontrado.",
          ),
        );
        return;
      }

      int userCoins = UserManager.currentUser!.moedaPermanente?.quantidade ?? 0;
      int savedInitialCoins =
          prefs.getInt('initial_coins_${UserManager.currentUser!.id}') ??
          userCoins;

      final List<Map<String, dynamic>> talents = [
        {
          "title": "Dano de Ataque",
          "icon": Icons.gavel,
          "level": prefs.getInt('talent_0_${UserManager.currentUser!.id}') ?? 1,
          "cost": 10,
        },
        {
          "title": "Dano de Crítico",
          "icon": Icons.bolt,
          "level": prefs.getInt('talent_1_${UserManager.currentUser!.id}') ?? 1,
          "cost": 10,
        },
        {
          "title": "Defesa",
          "icon": Icons.shield,
          "level": prefs.getInt('talent_2_${UserManager.currentUser!.id}') ?? 1,
          "cost": 10,
        },
        {
          "title": "Ganho de Moeda",
          "icon": Icons.attach_money,
          "level": prefs.getInt('talent_3_${UserManager.currentUser!.id}') ?? 1,
          "cost": 10,
        },
      ];

      emit(
        state.copyWith(
          coins: userCoins,
          initialCoins: savedInitialCoins,
          talents: talents,
          isLoading: false,
        ),
      );

      await prefs.setInt(
        'initial_coins_${UserManager.currentUser!.id}',
        savedInitialCoins,
      );

      if (kDebugMode) logger.d("HabilidadesBloc inicializado com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode)
        logger.e("Erro ao inicializar HabilidadesBloc: $e\n$stackTrace");
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: "Erro ao carregar dados: $e",
        ),
      );
    }
  }

  Future<void> _onEnableAudio(
    EnableAudioEvent event,
    Emitter<HabilidadesState> emit,
  ) async {
    if (state.isAudioEnabled) return;

    try {
      await audioPlayer.setVolume(0.5);
      await audioPlayer.setSource(AssetSource('audios/ka-chin.mp3'));

      emit(state.copyWith(isAudioEnabled: true, showAudioPrompt: false));

      if (kDebugMode) logger.d("Áudio habilitado com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao habilitar áudio: $e\n$stackTrace");
      emit(state.copyWith(errorMessage: "Erro ao habilitar áudio: $e"));
    }
  }

  Future<void> _onUpgradeTalent(
    UpgradeTalentEvent event,
    Emitter<HabilidadesState> emit,
  ) async {
    if (!state.isAudioEnabled) {
      add(EnableAudioEvent());
      return;
    }

    final index = event.index;
    final currentTalent = state.talents[index];
    final cost = currentTalent["cost"] as int;

    if (state.coins < cost) {
      emit(state.copyWith(errorMessage: "Moedas insuficientes!"));
      return;
    }

    try {
      // Tocar som de moeda
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('audios/ka-chin.mp3'));
      if (kDebugMode) logger.d("Som de moeda tocado");

      // Atualizar estado
      final updatedTalents = List<Map<String, dynamic>>.from(state.talents);
      updatedTalents[index] = {
        ...currentTalent,
        "level": currentTalent["level"] + 1,
        "cost": (currentTalent["cost"] * 1.5).round(),
      };

      final newCoins = state.coins - cost;

      emit(
        state.copyWith(
          coins: newCoins,
          talents: updatedTalents,
          errorMessage:
              "Talento ${currentTalent["title"]} melhorado para o nível ${updatedTalents[index]["level"]}",
        ),
      );

      // Salvar dados
      final prefs = await SharedPreferences.getInstance();
      if (UserManager.currentUser == null) return;

      UserManager.currentUser = UserManager.currentUser!.copyWith(
        moedaPermanente:
            UserManager.currentUser!.moedaPermanente?.copyWith(
              quantidade: newCoins,
            ) ??
            MoedaPermanente(id: "default", quantidade: newCoins),
      );
      await UserManager.setUser(UserManager.currentUser!);
      await prefs.setInt('coins_${UserManager.currentUser!.id}', newCoins);
      await prefs.setInt(
        'talent_${index}_${UserManager.currentUser!.id}',
        updatedTalents[index]["level"],
      );

      if (kDebugMode) logger.d("Talento $index melhorado com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao melhorar talento: $e\n$stackTrace");
      emit(state.copyWith(errorMessage: "Erro ao melhorar talento: $e"));
    }
  }

  @override
  Future<void> close() async {
    await audioPlayer.stop();
    await audioPlayer.dispose();
    if (kDebugMode) logger.d("HabilidadesBloc fechado");
    return super.close();
  }
}

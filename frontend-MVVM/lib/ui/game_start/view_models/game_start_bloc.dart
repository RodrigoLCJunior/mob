/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components do game_start
 ** Obs...:
 */

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';

// Eventos
abstract class GameStartEvent extends Equatable {
  const GameStartEvent();

  @override
  List<Object?> get props => [];
}

class InitializeEvent extends GameStartEvent {}

class EnableAudioEvent extends GameStartEvent {}

class AdventureTappedEvent extends GameStartEvent {
  final int index;

  const AdventureTappedEvent(this.index);

  @override
  List<Object?> get props => [index];
}

class ScrollChangedEvent extends GameStartEvent {
  final double pageValue;

  const ScrollChangedEvent(this.pageValue);

  @override
  List<Object?> get props => [pageValue];
}

class OpenAccountOptionsEvent extends GameStartEvent {}

class OpenHabilidadesEvent extends GameStartEvent {}

class OpenSettingsEvent extends GameStartEvent {}

class ClearErrorMessageEvent extends GameStartEvent {} // <- NOVO EVENTO

// Estado
class GameStartState extends Equatable {
  final bool isLayoutReady;
  final bool hasError;
  final String? errorMessage;
  final double currentPageValue;
  final int lastPage;
  final List<Map<String, dynamic>> adventures;
  final String userName;
  final int coinAmount;
  final bool isAudioEnabled;
  final bool showAudioPrompt;

  const GameStartState({
    this.isLayoutReady = false,
    this.hasError = false,
    this.errorMessage,
    this.currentPageValue = 0.0,
    this.lastPage = 0,
    this.adventures = const [],
    this.userName = "Usuário",
    this.coinAmount = 0,
    this.isAudioEnabled = false,
    this.showAudioPrompt = kIsWeb,
  });

  GameStartState copyWith({
    bool? isLayoutReady,
    bool? hasError,
    String? errorMessage,
    double? currentPageValue,
    int? lastPage,
    List<Map<String, dynamic>>? adventures,
    String? userName,
    int? coinAmount,
    bool? isAudioEnabled,
    bool? showAudioPrompt,
  }) {
    return GameStartState(
      isLayoutReady: isLayoutReady ?? this.isLayoutReady,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage,
      currentPageValue: currentPageValue ?? this.currentPageValue,
      lastPage: lastPage ?? this.lastPage,
      adventures: adventures ?? this.adventures,
      userName: userName ?? this.userName,
      coinAmount: coinAmount ?? this.coinAmount,
      isAudioEnabled: isAudioEnabled ?? this.isAudioEnabled,
      showAudioPrompt: showAudioPrompt ?? this.showAudioPrompt,
    );
  }

  @override
  List<Object?> get props => [
        isLayoutReady,
        hasError,
        errorMessage,
        currentPageValue,
        lastPage,
        adventures,
        userName,
        coinAmount,
        isAudioEnabled,
        showAudioPrompt,
      ];
}

// Bloc
class GameStartBloc extends Bloc<GameStartEvent, GameStartState> {
  final AudioPlayer audioPlayer;
  final AudioPlayer backgroundAudioPlayer;
  final Logger logger;

  GameStartBloc({
    required this.audioPlayer,
    required this.backgroundAudioPlayer,
  })  : logger = Logger(),
        super(const GameStartState()) {
    on<InitializeEvent>(_onInitialize);
    on<EnableAudioEvent>(_onEnableAudio);
    on<AdventureTappedEvent>(_onAdventureTapped);
    on<ScrollChangedEvent>(_onScrollChanged);
    on<OpenAccountOptionsEvent>(_onOpenAccountOptions);
    on<OpenHabilidadesEvent>(_onOpenHabilidades);
    on<OpenSettingsEvent>(_onOpenSettings);
    on<ClearErrorMessageEvent>(_onClearErrorMessage); // <- HANDLER NOVO

    add(InitializeEvent());
  }

  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<GameStartState> emit,
  ) async {
    try {
      final List<Map<String, dynamic>> adventures = [
        {
          "title": "A Floresta Sombria",
          "desc": "Uma jornada inicial cheia de mistérios.",
          "locked": false,
        },
        {
          "title": "Noite Eterna",
          "desc": "Enfrente desafios sob a luz da lua.",
          "locked": false,
        },
        {
          "title": "Abismo Esquecido",
          "desc": "Descubra segredos antigos.",
          "locked": true,
        },
        {
          "title": "Coração da Escuridão",
          "desc": "A aventura suprema.",
          "locked": true,
        },
        {
          "title": "Rastro do Caos",
          "desc": "Sobreviva ao imprevisível.",
          "locked": true,
        },
      ];

      emit(
        state.copyWith(
          adventures: adventures,
          userName: UserManager.currentUser?.nome ?? "Usuário",
          coinAmount:
              UserManager.currentUser?.moedaPermanente?.quantidade ?? 0,
          isLayoutReady: true,
        ),
      );

      if (kDebugMode) logger.d("GameStartBloc inicializado com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode)
        logger.e("Erro ao inicializar GameStartBloc: $e\n$stackTrace");
      emit(state.copyWith(hasError: true, errorMessage: "Erro ao inicializar: $e"));
    }
  }

  Future<void> _onEnableAudio(
    EnableAudioEvent event,
    Emitter<GameStartState> emit,
  ) async {
    if (state.isAudioEnabled) return;

    try {
      await audioPlayer.setVolume(0.5);

      await backgroundAudioPlayer.setVolume(0.3);
      await backgroundAudioPlayer.setReleaseMode(ReleaseMode.loop);
      await backgroundAudioPlayer.play(
        AssetSource('audios/game_background.mp3'),
      );

      emit(state.copyWith(isAudioEnabled: true, showAudioPrompt: false));

      if (kDebugMode) logger.d("Áudio habilitado com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao habilitar áudio: $e\n$stackTrace");
      emit(state.copyWith(errorMessage: "Erro ao habilitar áudio: $e"));
    }
  }

  Future<void> _onAdventureTapped(
    AdventureTappedEvent event,
    Emitter<GameStartState> emit,
  ) async {
    if (!state.isAudioEnabled) {
      add(EnableAudioEvent());
      return;
    }

    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('audios/pop.wav'));

      final adventure = state.adventures[event.index];
      final bool isLocked = adventure["locked"] as bool;

      if (isLocked) {
        emit(state.copyWith(errorMessage: "Esta aventura está bloqueada!"));
      } else {
        emit(state.copyWith(errorMessage: "Iniciando aventura ${event.index + 1}..."));
      }
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao iniciar aventura: $e\n$stackTrace");
      emit(state.copyWith(errorMessage: "Erro ao iniciar aventura: $e"));
    }
  }

  Future<void> _onScrollChanged(
    ScrollChangedEvent event,
    Emitter<GameStartState> emit,
  ) async {
    if (!state.isAudioEnabled) {
      add(EnableAudioEvent());
      return;
    }

    final newPageValue = event.pageValue;
    final newPage = newPageValue.round();

    if ((state.currentPageValue - newPageValue).abs() > 0.01) {
      emit(state.copyWith(currentPageValue: newPageValue));
    }

    if ((state.currentPageValue - newPage).abs() < 0.1 &&
        newPage != state.lastPage) {
      emit(state.copyWith(lastPage: newPage));
      try {
        await audioPlayer.stop();
        await audioPlayer.play(AssetSource('audios/woosh.mp3'));
      } catch (e, stackTrace) {
        if (kDebugMode) logger.e("Erro ao tocar som de scroll: $e\n$stackTrace");
      }
    }
  }

  Future<void> _onOpenAccountOptions(
    OpenAccountOptionsEvent event,
    Emitter<GameStartState> emit,
  ) async {
    if (!state.isAudioEnabled) {
      add(EnableAudioEvent());
      return;
    }

    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('audios/tec.wav'));
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao tocar som de clique: $e\n$stackTrace");
    }
  }

  Future<void> _onOpenHabilidades(
    OpenHabilidadesEvent event,
    Emitter<GameStartState> emit,
  ) async {
    if (!state.isAudioEnabled) {
      add(EnableAudioEvent());
      return;
    }

    try {
      await audioPlayer.stop();
      await audioPlayer.play(AssetSource('audios/tec.wav'));
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao tocar som de clique: $e\n$stackTrace");
    }
  }

  Future<void> _onOpenSettings(
    OpenSettingsEvent event,
    Emitter<GameStartState> emit,
  ) async {
    emit(state.copyWith(errorMessage: "Configurações em breve!"));
  }

  Future<void> _onClearErrorMessage(
    ClearErrorMessageEvent event,
    Emitter<GameStartState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null, hasError: false));
  }

  @override
  Future<void> close() async {
    await audioPlayer.stop();
    await audioPlayer.dispose();
    await backgroundAudioPlayer.stop();
    await backgroundAudioPlayer.dispose();
    if (kDebugMode) logger.d("GameStartBloc fechado");
    return super.close();
  }
}

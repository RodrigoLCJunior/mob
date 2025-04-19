import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/config/app_config.dart';
import 'package:midnight_never_end/data/services/user_manager.dart';
import '../../../core/enum/audio_type.dart';
import '../../../data/services/backend_pinger.dart';
import '../../../utils/logger.dart';
import 'intro_event.dart';
import 'intro_state.dart';

class IntroViewModel extends Bloc<IntroEvent, IntroState> {
  final Random _random = Random();
  final List<String> _lightningImages = [
    "assets/images/lightning.png",
    "assets/images/lightning2.png",
    "assets/images/lightning3.png",
  ];
  Timer? _keepAliveTimer;

  IntroViewModel() : super(IntroState()) {
    on<InitializeIntroEvent>(_onInitialize);
    on<TapBackgroundEvent>(_onTapBackground);
    on<StartGameEvent>(_onStartGame);
    on<PlayThunderSoundEvent>(_onPlayThunderSound);
    on<PlayPressHereSoundEvent>(_onPlayPressHereSound);
    on<PlayBackgroundMusicEvent>(_onPlayBackgroundMusic);
    on<PauseBackgroundMusicEvent>(_onPauseBackgroundMusic);
    on<ResumeBackgroundMusicEvent>(_onResumeBackgroundMusic);
    on<StopBackgroundMusicEvent>(_onStopBackgroundMusic);
    on<ResetPressHereSoundEvent>(_onResetPressHereSound);
  }

  Future<void> _onInitialize(
    InitializeIntroEvent event,
    Emitter<IntroState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _pingBackend();
      _startKeepAlive();
      emit(
        state.copyWith(
          isLoading: false,
          logoFadeInCompleted: true,
          pressHereFadeInCompleted: true,
        ),
      );
      add(PlayBackgroundMusicEvent());
    } catch (e) {
      emit(state.copyWith(errorMessage: "Erro ao inicializar: $e"));
    }
  }

  Future<void> _onTapBackground(
    TapBackgroundEvent event,
    Emitter<IntroState> emit,
  ) async {
    if (!state.showFlash && !state.isBlinkingFast) {
      emit(
        state.copyWith(
          showFlash: true,
          currentLightning:
              _lightningImages[_random.nextInt(_lightningImages.length)],
        ),
      );

      if (!state.hasChangedBackground) {
        emit(
          state.copyWith(
            currentBackgroundImage: "assets/images/background_image2.png",
            hasChangedBackground: true,
            showRain: true,
          ),
        );
      }

      add(PlayThunderSoundEvent());

      // Aguardar 200ms antes de desativar o flash
      await Future.delayed(const Duration(milliseconds: 200));
      if (state.showFlash) {
        emit(state.copyWith(showFlash: false));
      }
    }
  }

  Future<void> _onStartGame(
    StartGameEvent event,
    Emitter<IntroState> emit,
  ) async {
    if (!state.isBlinkingFast) {
      if (!state.hasPlayedPressHereSound) {
        Logger.log("Disparando PlayPressHereSoundEvent");
        add(PlayPressHereSoundEvent());
        emit(state.copyWith(hasPlayedPressHereSound: true));
      }
      emit(state.copyWith(isBlinkingFast: true));
      await Future.delayed(const Duration(seconds: 2));
      emit(state.copyWith(isBlinkingFast: false));
      // Aqui você pode implementar a navegação pro LoginModal e GameStartScreen
    }
  }

  Future<void> _onPlayThunderSound(
    PlayThunderSoundEvent event,
    Emitter<IntroState> emit,
  ) async {
    try {
      Logger.log("Tentando parar o som do trovão...");
      await AppConfig.audioService.stopAudio('thunder.wav');
      Logger.log("Tentando tocar o som do trovão...");
      await AppConfig.audioService.playAudio('thunder.wav', AudioType.effect);
      Logger.log("Som do trovão tocado com sucesso");
    } catch (e) {
      Logger.log("Erro ao tocar trovão: $e");
      emit(state.copyWith(errorMessage: "Erro ao tocar trovão: $e"));
    }
  }

  Future<void> _onPlayPressHereSound(
    PlayPressHereSoundEvent event,
    Emitter<IntroState> emit,
  ) async {
    try {
      Logger.log("Tentando parar o som de press_here...");
      await AppConfig.audioService.stopAudio('press_here.wav');
      Logger.log("Tentando tocar o som de press_here...");
      await AppConfig.audioService.playAudio(
        'press_here.wav',
        AudioType.effect,
      );
      Logger.log("Som de press_here tocado com sucesso");
    } catch (e) {
      Logger.log("Erro ao tocar press_here: $e");
      emit(state.copyWith(errorMessage: "Erro ao tocar press_here: $e"));
    }
  }

  Future<void> _onPlayBackgroundMusic(
    PlayBackgroundMusicEvent event,
    Emitter<IntroState> emit,
  ) async {
    try {
      Logger.log("Tentando tocar música de fundo...");
      await AppConfig.audioService.playAudio(
        'sons_of_liberty.mp3',
        AudioType.background,
        volume: 0.5,
      );
      Logger.log("Música de fundo tocada com sucesso");
      emit(state.copyWith(isMusicPlaying: true));
    } catch (e) {
      Logger.log("Erro ao tocar música: $e");
      emit(state.copyWith(errorMessage: "Erro ao tocar música: $e"));
    }
  }

  Future<void> _onPauseBackgroundMusic(
    PauseBackgroundMusicEvent event,
    Emitter<IntroState> emit,
  ) async {
    try {
      Logger.log("Tentando pausar música de fundo...");
      await AppConfig.audioService.stopAudio('sons_of_liberty.mp3');
      Logger.log("Música de fundo pausada");
      emit(state.copyWith(isMusicPlaying: false));
    } catch (e) {
      Logger.log("Erro ao pausar música: $e");
      emit(state.copyWith(errorMessage: "Erro ao pausar música: $e"));
    }
  }

  Future<void> _onResumeBackgroundMusic(
    ResumeBackgroundMusicEvent event,
    Emitter<IntroState> emit,
  ) async {
    try {
      Logger.log("Tentando retomar música de fundo...");
      await AppConfig.audioService.playAudio(
        'sons_of_liberty.mp3',
        AudioType.background,
        volume: 0.5,
      );
      Logger.log("Música de fundo retomada");
      emit(state.copyWith(isMusicPlaying: true));
    } catch (e) {
      Logger.log("Erro ao retomar música: $e");
      emit(state.copyWith(errorMessage: "Erro ao retomar música: $e"));
    }
  }

  Future<void> _onStopBackgroundMusic(
    StopBackgroundMusicEvent event,
    Emitter<IntroState> emit,
  ) async {
    try {
      Logger.log("Tentando parar música de fundo...");
      await AppConfig.audioService.stopAudio('sons_of_liberty.mp3');
      Logger.log("Música de fundo parada");
      emit(state.copyWith(isMusicPlaying: false));
    } catch (e) {
      Logger.log("Erro ao parar música: $e");
      emit(state.copyWith(errorMessage: "Erro ao parar música: $e"));
    }
  }

  Future<void> _onResetPressHereSound(
    ResetPressHereSoundEvent event,
    Emitter<IntroState> emit,
  ) async {
    Logger.log("Resetando o estado do som de press_here...");
    emit(state.copyWith(hasPlayedPressHereSound: false));
    Logger.log("Estado do som de press_here resetado");
  }

  Future<void> _pingBackend() async {
    final stopwatch = Stopwatch()..start();
    await BackendPinger.pingBackend();
    stopwatch.stop();
    Logger.log(
      "Ping inicial - Tempo total: ${stopwatch.elapsed.inMilliseconds / 1000} segundos",
    );
  }

  void _startKeepAlive() {
    _keepAliveTimer?.cancel();
    _keepAliveTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (UserManager.currentUser == null) {
        BackendPinger.pingBackend();
        Logger.log("Keep-alive ping enviado em ${DateTime.now()}");
      } else {
        timer.cancel();
        Logger.log("Keep-alive cancelado - Usuário logado");
      }
    });
  }

  @override
  Future<void> close() {
    _keepAliveTimer?.cancel();
    return super.close();
  }
}

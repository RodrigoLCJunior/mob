/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components do intro
 ** Obs...:
 */

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/core/service/intro/intro_service.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';
import 'package:midnight_never_end/main.dart';
import 'package:midnight_never_end/ui/auth/login/pages/login_modal.dart';
import 'package:midnight_never_end/ui/game_start/pages/game_start_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


// Eventos
abstract class IntroEvent extends Equatable {
  const IntroEvent();

  @override
  List<Object?> get props => [];
}

class InitializeEvent extends IntroEvent {}

class HandleTapEvent extends IntroEvent {}

class PlayThunderSoundEvent extends IntroEvent {}

class StartGameEvent extends IntroEvent {}

class CenterImageEvent extends IntroEvent {
  final Size screenSize;

  const CenterImageEvent(this.screenSize);

  @override
  List<Object?> get props => [screenSize];
}

class ToggleFlashEvent extends IntroEvent {
  final bool showFlash;

  const ToggleFlashEvent(this.showFlash);

  @override
  List<Object?> get props => [showFlash];
}

class LogoFadeInCompletedEvent extends IntroEvent {}

class PressHereFadeInCompletedEvent extends IntroEvent {}

// Estado
class IntroState extends Equatable {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final bool showFlash;
  final bool isBlinkingFast;
  final bool logoFadeInCompleted;
  final bool pressHereFadeInCompleted;
  final String currentLightning;
  final List<String> lightningImages;
  final String currentBackgroundImage;
  final bool hasChangedBackground;
  final Size? imageSize;
  final Size? screenSize;
  final bool isDragging;
  final Matrix4 transformationMatrix;
  final Duration blinkDuration;

  IntroState({
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.showFlash = false,
    this.isBlinkingFast = false,
    this.logoFadeInCompleted = false,
    this.pressHereFadeInCompleted = false,
    this.currentLightning = "assets/images/lightning.png",
    this.lightningImages = const [
      "assets/images/lightning.png",
      "assets/images/lightning2.png",
      "assets/images/lightning3.png",
    ],
    this.currentBackgroundImage = "assets/images/background_image.png",
    this.hasChangedBackground = false,
    this.imageSize,
    this.screenSize,
    this.isDragging = false,
    Matrix4? transformationMatrix,
    this.blinkDuration = const Duration(seconds: 2),
  }) : transformationMatrix = transformationMatrix ?? Matrix4.identity();

  IntroState copyWith({
    bool? isLoading,
    bool? hasError,
    String? errorMessage,
    bool? showFlash,
    bool? isBlinkingFast,
    bool? logoFadeInCompleted,
    bool? pressHereFadeInCompleted,
    String? currentLightning,
    List<String>? lightningImages,
    String? currentBackgroundImage,
    bool? hasChangedBackground,
    Size? imageSize,
    Size? screenSize,
    bool? isDragging,
    Matrix4? transformationMatrix,
    Duration? blinkDuration,
  }) {
    return IntroState(
      isLoading: isLoading ?? this.isLoading,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
      showFlash: showFlash ?? this.showFlash,
      isBlinkingFast: isBlinkingFast ?? this.isBlinkingFast,
      logoFadeInCompleted: logoFadeInCompleted ?? this.logoFadeInCompleted,
      pressHereFadeInCompleted:
          pressHereFadeInCompleted ?? this.pressHereFadeInCompleted,
      currentLightning: currentLightning ?? this.currentLightning,
      lightningImages: lightningImages ?? this.lightningImages,
      currentBackgroundImage:
          currentBackgroundImage ?? this.currentBackgroundImage,
      hasChangedBackground: hasChangedBackground ?? this.hasChangedBackground,
      imageSize: imageSize ?? this.imageSize,
      screenSize: screenSize ?? this.screenSize,
      isDragging: isDragging ?? this.isDragging,
      transformationMatrix: transformationMatrix ?? this.transformationMatrix,
      blinkDuration: blinkDuration ?? this.blinkDuration,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    hasError,
    errorMessage,
    showFlash,
    isBlinkingFast,
    logoFadeInCompleted,
    pressHereFadeInCompleted,
    currentLightning,
    lightningImages,
    currentBackgroundImage,
    hasChangedBackground,
    imageSize,
    screenSize,
    isDragging,
    transformationMatrix,
    blinkDuration,
  ];
}

// Bloc
class IntroBloc extends Bloc<IntroEvent, IntroState> {
  final IntroService introService;
  final Random _random = Random();

  IntroBloc({required this.introService}) : super(IntroState()) {
    on<InitializeEvent>(_onInitialize);
    on<HandleTapEvent>(_onHandleTap);
    on<PlayThunderSoundEvent>(_onPlayThunderSound);
    on<ToggleFlashEvent>(_onToggleFlash);
    on<StartGameEvent>(_onStartGame);
    on<CenterImageEvent>(_onCenterImage);
    on<LogoFadeInCompletedEvent>(_onLogoFadeInCompleted);
    on<PressHereFadeInCompletedEvent>(_onPressHereFadeInCompleted);

    // Inicializar ao criar o Bloc
    add(InitializeEvent());
  }

  Future<void> _onInitialize(
    InitializeEvent event,
    Emitter<IntroState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      await introService.loadAllImageSizes();
      await introService.pingBackend();
      introService.startKeepAlive();
      emit(
        state.copyWith(
          isLoading: false,
          imageSize: introService.backgroundImageSize,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: "Erro ao inicializar: $e",
        ),
      );
    }
  }

  Future<void> _onHandleTap(
  HandleTapEvent event,
  Emitter<IntroState> emit,
) async {
  if (!state.showFlash && !state.isBlinkingFast && !state.isDragging) {
    try {
      // Inicia música no web após o primeiro toque
      if (kIsWeb && !introService.hasStartedBackgroundMusic) {
        await introService.startBackgroundMusic();
      }

      final currentTransform = state.transformationMatrix.clone();

      emit(
        state.copyWith(
          showFlash: true,
          currentLightning: state.lightningImages[
            _random.nextInt(state.lightningImages.length)
          ],
          currentBackgroundImage: state.hasChangedBackground
              ? state.currentBackgroundImage
              : "assets/images/background_image2.png",
          hasChangedBackground: true,
          imageSize: state.hasChangedBackground
              ? state.imageSize
              : introService.backgroundImage2Size,
          transformationMatrix: currentTransform,
        ),
      );

      add(PlayThunderSoundEvent());

      await Future.delayed(const Duration(milliseconds: 200));
      emit(state.copyWith(showFlash: false));
    } catch (e) {
      emit(state.copyWith(
        hasError: true,
        errorMessage: "Erro no handleTap: $e",
      ));
    }
  }
}


  Future<void> _onPlayThunderSound(
    PlayThunderSoundEvent event,
    Emitter<IntroState> emit,
  ) async {
    try {
      await introService.playThunderSound();
    } catch (e) {
      emit(
        state.copyWith(
          hasError: true,
          errorMessage: "Erro ao tocar trovão: $e",
        ),
      );
    }
  }

  Future<void> _onToggleFlash(
    ToggleFlashEvent event,
    Emitter<IntroState> emit,
  ) async {
    emit(state.copyWith(showFlash: event.showFlash));
  }

  Future<void> _onStartGame(
  StartGameEvent event,
  Emitter<IntroState> emit,
  ) async {
    if (!state.isBlinkingFast && !state.isDragging) {
      try {
        if (!introService.hasPlayedPressHereSound) {
          await introService.playPressHereSound();
        }

        // Blink rápido
        for (int i = 0; i < 5; i++) {
          emit(state.copyWith(
            isBlinkingFast: true,
            blinkDuration: const Duration(milliseconds: 200),
          ));
          await Future.delayed(const Duration(milliseconds: 200));
        }

        emit(state.copyWith(
          isBlinkingFast: false,
          blinkDuration: const Duration(seconds: 2),
        ));

        // Navegação condicional
        final isLoggedIn = UserManager.currentUser != null;
        final context = navigatorKey.currentContext!;

        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const GameStartScreen()),
          );
        } else {
          await showLoginModal(context);
        }
      } catch (e) {
        emit(state.copyWith(
          hasError: true,
          errorMessage: "Erro no startGame: $e",
        ));
      }
    }
  }


  Future<void> _onCenterImage(
    CenterImageEvent event,
    Emitter<IntroState> emit,
  ) async {
    if (state.imageSize == null) return;

    // Apenas atualizar o screenSize, sem centralizar a imagem
    emit(state.copyWith(screenSize: event.screenSize));
  }

  Future<void> _onLogoFadeInCompleted(
    LogoFadeInCompletedEvent event,
    Emitter<IntroState> emit,
  ) async {
    emit(state.copyWith(logoFadeInCompleted: true));
  }

  Future<void> _onPressHereFadeInCompleted(
    PressHereFadeInCompletedEvent event,
    Emitter<IntroState> emit,
  ) async {
    emit(state.copyWith(pressHereFadeInCompleted: true));
  }
}

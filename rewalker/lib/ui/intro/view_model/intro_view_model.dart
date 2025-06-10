import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/domain/entities/intro/intro_entity.dart';

class IntroViewModel extends Cubit<IntroEntity> {
  IntroViewModel() : super(IntroEntity());

  final List<String> _lightningImages = [
    "assets/images/lightning.png",
    "assets/images/lightning2.png",
    "assets/images/lightning3.png",
  ];
  final Random _random = Random();

  Future<Size> _loadImageSize(String imagePath) async {
    final imageProvider = AssetImage(imagePath);
    final completer = Completer<Size>();
    final stream = imageProvider.resolve(const ImageConfiguration());
    late ImageStreamListener listener;
    listener = ImageStreamListener((info, _) {
      completer.complete(
        Size(info.image.width.toDouble(), info.image.height.toDouble()),
      );
      stream.removeListener(listener);
    });
    stream.addListener(listener);
    return completer.future;
  }

  Future<void> ensureInitialImageSize() async {
    if (state.imageSize == null) {
      final size = await _loadImageSize(state.backgroundImage);
      emit(state.copyWith(imageSize: size));
    }
  }

  Future<void> triggerThunderAndChangeBackground() async {
    final newBg = 'assets/images/background_image2.png';
    final nextLightning =
        _lightningImages[_random.nextInt(_lightningImages.length)];
    final imageSize = await _loadImageSize(newBg);

    emit(
      state.copyWith(
        backgroundImage: newBg,
        hasChangedBackground: true,
        imageSize: imageSize,
        showFlash: true,
        currentLightning: nextLightning,
      ),
    );
  }

  Future<void> triggerThunderOnly() async {
    final nextLightning =
        _lightningImages[_random.nextInt(_lightningImages.length)];
    emit(state.copyWith(showFlash: true, currentLightning: nextLightning));
  }

  void resetFlash() {
    if (state.showFlash) {
      emit(state.copyWith(showFlash: false));
    }
  }

  void setTransformationMatrix(Matrix4 matrix) {
    emit(state.copyWith(transformationMatrix: matrix.clone()));
  }

  Future<void> startFastBlinkingNTimes(
    int times,
    Duration durationPerBlink,
  ) async {
    for (int i = 0; i < times; i++) {
      emit(state.copyWith(isBlinkingFast: true));
      await Future.delayed(durationPerBlink);
      emit(state.copyWith(isBlinkingFast: false));
      await Future.delayed(durationPerBlink);
    }
  }

  // ---- Music and Sound Flags (if you want to control via state) ----
  void playBackgroundMusic() {
    emit(state.copyWith(isMusicPlaying: true));
  }

  void stopBackgroundMusic() {
    emit(state.copyWith(isMusicPlaying: false));
  }

  void playThunderSound() {
    emit(state.copyWith(playThunderSound: true));
  }

  void resetThunderSound() {
    emit(state.copyWith(playThunderSound: false));
  }

  void playPressHereSound() {
    emit(state.copyWith(playPressHereSound: true));
  }

  void resetPressHereSound() {
    emit(state.copyWith(playPressHereSound: false));
  }
}

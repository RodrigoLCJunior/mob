import 'package:flutter/material.dart';
import 'package:midnight_never_end/ui/intro/view_model/rain_manager.dart';

class IntroEntity {
  final String userName;
  final String backgroundImage;
  final bool showFlash;
  final bool isBlinkingFast;
  final bool showRain;
  final String currentLightning;
  final bool hasChangedBackground;
  final bool isMusicPlaying;
  final bool playThunderSound;
  final bool playPressHereSound;
  final Size? imageSize;
  final Size? backgroundImageSize;
  final Size? backgroundImage2Size;
  final bool isDragging;
  final List<RainDrop> rainDrops;
  final Matrix4 transformationMatrix;

  IntroEntity({
    this.userName = 'Conta',
    this.backgroundImage = 'assets/images/background_image.png',
    this.showFlash = false,
    this.isBlinkingFast = false,
    this.showRain = false,
    this.currentLightning = 'assets/images/lightning.png',
    this.hasChangedBackground = false,
    this.isMusicPlaying = false,
    this.playThunderSound = false,
    this.playPressHereSound = false,
    this.imageSize,
    this.backgroundImageSize,
    this.backgroundImage2Size,
    this.isDragging = false,
    this.rainDrops = const [],
    Matrix4? transformationMatrix,
  }) : transformationMatrix = transformationMatrix ?? Matrix4.identity();

  IntroEntity copyWith({
    String? userName,
    String? backgroundImage,
    bool? showFlash,
    bool? isBlinkingFast,
    bool? showRain,
    String? currentLightning,
    bool? hasChangedBackground,
    bool? isMusicPlaying,
    bool? playThunderSound,
    bool? playPressHereSound,
    Size? imageSize,
    Size? backgroundImageSize,
    Size? backgroundImage2Size,
    bool? isDragging,
    List<RainDrop>? rainDrops,
    Matrix4? transformationMatrix,
  }) {
    return IntroEntity(
      userName: userName ?? this.userName,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      showFlash: showFlash ?? this.showFlash,
      isBlinkingFast: isBlinkingFast ?? this.isBlinkingFast,
      showRain: showRain ?? this.showRain,
      currentLightning: currentLightning ?? this.currentLightning,
      hasChangedBackground: hasChangedBackground ?? this.hasChangedBackground,
      isMusicPlaying: isMusicPlaying ?? this.isMusicPlaying,
      playThunderSound: playThunderSound ?? this.playThunderSound,
      playPressHereSound: playPressHereSound ?? this.playPressHereSound,
      imageSize: imageSize ?? this.imageSize,
      backgroundImageSize: backgroundImageSize ?? this.backgroundImageSize,
      backgroundImage2Size: backgroundImage2Size ?? this.backgroundImage2Size,
      isDragging: isDragging ?? this.isDragging,
      rainDrops: rainDrops ?? this.rainDrops,
      transformationMatrix: transformationMatrix ?? this.transformationMatrix,
    );
  }
}

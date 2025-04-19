class IntroState {
  final bool isLoading;
  final bool showFlash;
  final bool isBlinkingFast;
  final bool showRain;
  final bool logoFadeInCompleted;
  final bool pressHereFadeInCompleted;
  final bool hasPlayedPressHereSound;
  final bool hasChangedBackground;
  final bool isMusicPlaying;
  final String currentLightning;
  final String currentBackgroundImage;
  final String errorMessage;

  IntroState({
    this.isLoading = true,
    this.showFlash = false,
    this.isBlinkingFast = false,
    this.showRain = false,
    this.logoFadeInCompleted = false,
    this.pressHereFadeInCompleted = false,
    this.hasPlayedPressHereSound = false,
    this.hasChangedBackground = false,
    this.isMusicPlaying = false,
    this.currentLightning = "assets/images/lightning.png",
    this.currentBackgroundImage = "assets/images/background_image.png",
    this.errorMessage = "",
  });

  IntroState copyWith({
    bool? isLoading,
    bool? showFlash,
    bool? isBlinkingFast,
    bool? showRain,
    bool? logoFadeInCompleted,
    bool? pressHereFadeInCompleted,
    bool? hasPlayedPressHereSound,
    bool? hasChangedBackground,
    bool? isMusicPlaying,
    String? currentLightning,
    String? currentBackgroundImage,
    String? errorMessage,
  }) {
    return IntroState(
      isLoading: isLoading ?? this.isLoading,
      showFlash: showFlash ?? this.showFlash,
      isBlinkingFast: isBlinkingFast ?? this.isBlinkingFast,
      showRain: showRain ?? this.showRain,
      logoFadeInCompleted: logoFadeInCompleted ?? this.logoFadeInCompleted,
      pressHereFadeInCompleted:
          pressHereFadeInCompleted ?? this.pressHereFadeInCompleted,
      hasPlayedPressHereSound:
          hasPlayedPressHereSound ?? this.hasPlayedPressHereSound,
      hasChangedBackground: hasChangedBackground ?? this.hasChangedBackground,
      isMusicPlaying: isMusicPlaying ?? this.isMusicPlaying,
      currentLightning: currentLightning ?? this.currentLightning,
      currentBackgroundImage:
          currentBackgroundImage ?? this.currentBackgroundImage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

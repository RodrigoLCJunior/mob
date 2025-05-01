/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Tela de Intro
 ** Obs...:
 */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/core/service/intro/intro_service.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';
import 'package:midnight_never_end/ui/auth/login/pages/login_modal.dart';
import 'package:midnight_never_end/ui/game_start/pages/game_start_screen.dart';
import 'package:midnight_never_end/ui/intro/view_models/intro_bloc.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IntroBloc(introService: IntroService()),
      child: const IntroScreenContent(),
    );
  }
}

class IntroScreenContent extends StatefulWidget {
  const IntroScreenContent({super.key});

  @override
  _IntroScreenContentState createState() => _IntroScreenContentState();
}

class _IntroScreenContentState extends State<IntroScreenContent>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late AnimationController _logoController;
  late AnimationController _pressHereController;
  late Animation<double> _logoOpacity;
  late Animation<double> _flashOpacity;
  late Animation<double> _blinkOpacity;
  late Animation<double> _shineAnimation;
  late Animation<double> _pressHereOpacity;

  DateTime? _tapDownTime;
  final Duration _tapThreshold = const Duration(milliseconds: 200);
  final TransformationController _transformationController =
      TransformationController();
  Size? _previousImageSize; // Para armazenar o tamanho da imagem anterior
  Duration _lastBlinkDuration = const Duration(
    seconds: 2,
  ); // Para rastrear mudanças

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );

    _pressHereController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _flashOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _blinkOpacity = Tween<double>(
      begin: 0.1,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _pressHereOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pressHereController, curve: Curves.easeIn),
    );

    _logoController.forward().then((_) {
      if (mounted) {
        context.read<IntroBloc>().add(LogoFadeInCompletedEvent());
      }
    });

    _pressHereController.forward().then((_) {
      if (mounted) {
        context.read<IntroBloc>().add(PressHereFadeInCompletedEvent());
      }
    });

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.stop();
    _controller.dispose();
    _logoController.stop();
    _logoController.dispose();
    _pressHereController.stop();
    _pressHereController.dispose();
    _transformationController.dispose();
    context.read<IntroBloc>().introService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final introService = context.read<IntroBloc>().introService;
    if (state == AppLifecycleState.paused) {
      introService.pauseMusic();
    } else if (state == AppLifecycleState.resumed) {
      introService.resumeMusic();
    }
  }

  void _startGame() {
    if (!context.read<IntroBloc>().state.isBlinkingFast &&
        !context.read<IntroBloc>().state.isDragging) {
      context.read<IntroBloc>().add(StartGameEvent());
    }
  }

  void _centerImage(Size imageSize, Size screenSize) {
    final double offsetX = (screenSize.width - imageSize.width) / 2;
    final double offsetY = (screenSize.height - imageSize.height) / 2;

    _transformationController.value =
        Matrix4.identity()..translate(offsetX, offsetY);
  }

  Matrix4 _adjustTransformationMatrix(
    Matrix4 oldMatrix,
    Size oldSize,
    Size newSize,
  ) {
    final oldCenterX = oldSize.width / 2;
    final oldCenterY = oldSize.height / 2;
    final translation = oldMatrix.getTranslation();
    final currentX = -translation.x + oldCenterX;
    final currentY = -translation.y + oldCenterY;
    final relativeX = currentX / oldSize.width;
    final relativeY = currentY / oldSize.height;
    final newX = relativeX * newSize.width;
    final newY = relativeY * newSize.height;
    final newTranslationX = -(newX - newSize.width / 2);
    final newTranslationY = -(newY - newSize.height / 2);
    return Matrix4.identity()..translate(newTranslationX, newTranslationY);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IntroBloc, IntroState>(
      listener: (context, state) {
        if (state.isBlinkingFast) {
          Future.delayed(const Duration(milliseconds: 1000), () async {
            if (!mounted) return;

            final isLoggedIn = UserManager.currentUser != null;

            if (isLoggedIn) {
              context.read<IntroBloc>().introService.stopMusic();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const GameStartScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            } else {
              final isLoginSuccess = await showLoginModal(context);

              if (mounted) {
                if (!isLoginSuccess) {
                  // reset som
                  context.read<IntroBloc>().add(ToggleFlashEvent(false));
                  context.read<IntroBloc>().introService.resetPressHereSound();
                } else {
                  context.read<IntroBloc>().introService.stopMusic();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameStartScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                }
              }
            }
          });
        }
      },
      child: BlocBuilder<IntroBloc, IntroState>(
        builder: (context, state) {
          if (state.hasError) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  "Ocorreu um erro: ${state.errorMessage}\nVerifique o log para detalhes.",
                  style: const TextStyle(color: Colors.red, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (state.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state.blinkDuration != _lastBlinkDuration) {
            _controller.stop();
            _controller.duration = state.blinkDuration;
            _controller.repeat(reverse: true);
            _lastBlinkDuration = state.blinkDuration;
          }

          if (state.transformationMatrix == Matrix4.identity() &&
              !state.hasChangedBackground &&
              state.imageSize != null) {
            _centerImage(state.imageSize!, MediaQuery.of(context).size);
            context.read<IntroBloc>().add(
              CenterImageEvent(MediaQuery.of(context).size),
            );
          }

          if (_previousImageSize != null &&
              state.imageSize != null &&
              _previousImageSize != state.imageSize) {
            _transformationController.value = _adjustTransformationMatrix(
              _transformationController.value,
              _previousImageSize!,
              state.imageSize!,
            );
          }
          _previousImageSize = state.imageSize;

          void onInteractionUpdate(ScaleUpdateDetails details) {
            final newTransform = _transformationController.value.clone();
            context.read<IntroBloc>().add(
              CenterImageEvent(MediaQuery.of(context).size),
            );
            context.read<IntroBloc>().state.copyWith(
              transformationMatrix: newTransform,
            );
          }

          return Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child:
                      state.imageSize == null
                          ? const Center(child: CircularProgressIndicator())
                          : GestureDetector(
                            onTapDown: (details) {
                              _tapDownTime = DateTime.now();
                            },
                            onTapUp: (details) {
                              if (_tapDownTime != null) {
                                final duration = DateTime.now().difference(
                                  _tapDownTime!,
                                );
                                if (duration <= _tapThreshold) {
                                  final currentTransform =
                                      _transformationController.value.clone();
                                  context.read<IntroBloc>().add(
                                    HandleTapEvent(),
                                  );
                                  _controller.stop();
                                  _controller.duration = const Duration(
                                    milliseconds: 200,
                                  );
                                  _controller.reset();
                                  _controller.forward();
                                  _transformationController.value =
                                      currentTransform;
                                }
                              }
                            },
                            child: InteractiveViewer(
                              transformationController:
                                  _transformationController,
                              constrained: false,
                              minScale: 1.0,
                              maxScale: 1.0,
                              onInteractionUpdate: onInteractionUpdate,
                              child: SizedBox(
                                key: ValueKey(state.currentBackgroundImage),
                                width: state.imageSize!.width,
                                height: state.imageSize!.height,
                                child: Image.asset(
                                  state.currentBackgroundImage,
                                  fit: BoxFit.cover,
                                  width: state.imageSize!.width,
                                  height: state.imageSize!.height,
                                ),
                              ),
                            ),
                          ),
                ),
                Align(
                  alignment: const Alignment(0, -0.5),
                  child: AnimatedBuilder(
                    animation: _shineAnimation,
                    builder: (context, child) {
                      return ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.8),
                              Colors.white.withOpacity(0.1),
                            ],
                            stops: [
                              _shineAnimation.value - 0.3,
                              _shineAnimation.value,
                              _shineAnimation.value + 0.3,
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcATop,
                        child: FadeTransition(
                          opacity:
                              state.logoFadeInCompleted
                                  ? const AlwaysStoppedAnimation(1.0)
                                  : _logoOpacity,
                          child: Image.asset(
                            "assets/images/re_walker.png",
                            width: 450,
                            height: 300,
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (state.showFlash)
                  FadeTransition(
                    opacity: _flashOpacity,
                    child: Center(
                      child: Image.asset(
                        state.currentLightning,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (state.showFlash)
                  FadeTransition(
                    opacity: _flashOpacity,
                    child: Container(
                      color: Colors.white.withOpacity(0.5),
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                if (context.read<IntroBloc>().introService.showAudioPrompt)
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black.withOpacity(0.7),
                      child: const Text(
                        "Toque na tela para ativar o som",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: GestureDetector(
                      onTap: _startGame,
                      behavior: HitTestBehavior.opaque,
                      child: FadeTransition(
                        opacity:
                            state.pressHereFadeInCompleted
                                ? _blinkOpacity
                                : _pressHereOpacity,
                        child: const Text(
                          "- PRESS HERE -",
                          style: TextStyle(
                            fontFamily: "Kirsty",
                            fontSize: 20,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 5.0,
                                color: Color.fromARGB(255, 40, 40, 40),
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
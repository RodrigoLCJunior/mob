import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/ui/user/view_models/user_view_model.dart';
import 'dart:math';
import '../../../data/services/user_manager.dart';
import '../../user/view_models/user_state.dart';
import '../view_models/intro_event.dart';
import '../view_models/intro_state.dart';
import '../view_models/intro_view_model.dart';
import '../../auth/pages/login_modal.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IntroViewModel()..add(InitializeIntroEvent()),
      child: BlocBuilder<IntroViewModel, IntroState>(
        builder: (context, introState) {
          return BlocBuilder<UserViewModel, UserState>(
            builder: (context, userState) {
              return _IntroScreenContent(
                userName:
                    userState is UserLoggedIn ? userState.user.nome : "Conta",
                introState: introState,
                onLogin: () {
                  return showLoginModal(context);
                },
                onStartGame: () {
                  if (UserManager.currentUser != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("GameStartScreen ainda não implementado"),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _IntroScreenContent extends StatefulWidget {
  final String userName;
  final IntroState introState;
  final Future<dynamic> Function() onLogin;
  final VoidCallback onStartGame;

  const _IntroScreenContent({
    required this.userName,
    required this.introState,
    required this.onLogin,
    required this.onStartGame,
  });

  @override
  _IntroScreenContentState createState() => _IntroScreenContentState();
}

class _IntroScreenContentState extends State<_IntroScreenContent>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late AnimationController _logoController;
  late AnimationController _pressHereController;
  late Ticker _rainTicker;
  late Animation<double> _logoOpacity;
  late Animation<double> _flashOpacity;
  late Animation<double> _blinkOpacity;
  late Animation<double> _shineAnimation;
  late Animation<double> _pressHereOpacity;

  Size? _imageSize;
  Size? _backgroundImageSize;
  Size? _backgroundImage2Size;
  Size? _screenSize;
  bool _isDragging = false;
  bool _isOpeningModal = false;
  int _blinkCount = 0;
  final TransformationController _transformationController =
      TransformationController();
  Matrix4? _lastTransformation;

  List<RainDrop> _rainDrops = [];
  final int _numberOfDrops = 50;
  final Random _random = Random();

  DateTime? _tapDownTime;
  final Duration _tapThreshold = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
    _loadAllImageSizes();
    _initializeRain();
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
      end: 2.0,
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
      debugPrint("Fade-in do logo concluído");
    });
    _pressHereController.forward();
    _controller.repeat(reverse: true);
  }

  void _initializeRain() {
    _rainDrops = List.generate(_numberOfDrops, (index) {
      return RainDrop(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speed: _random.nextDouble() * 5 + 5,
        length: _random.nextDouble() * 10 + 5,
      );
    });

    _rainTicker = createTicker((elapsed) {
      if (!widget.introState.showRain) return;

      setState(() {
        for (var drop in _rainDrops) {
          drop.y += drop.speed / 500;
          if (drop.y > 1) {
            drop.y = 0;
            drop.x = _random.nextDouble();
          }
        }
      });
    });

    if (widget.introState.showRain) {
      _rainTicker.start();
    }
  }

  @override
  void didUpdateWidget(_IntroScreenContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.introState.isBlinkingFast !=
        oldWidget.introState.isBlinkingFast) {
      if (widget.introState.isBlinkingFast) {
        _controller.stop();
        _controller.duration = const Duration(milliseconds: 200);
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.duration = const Duration(seconds: 2);
        _controller.repeat(reverse: true);
      }
    }

    if (widget.introState.showRain && !oldWidget.introState.showRain) {
      _rainTicker.start();
    } else if (!widget.introState.showRain && oldWidget.introState.showRain) {
      _rainTicker.stop();
    }

    if (widget.introState.currentBackgroundImage !=
        oldWidget.introState.currentBackgroundImage) {
      _lastTransformation = _transformationController.value.clone();

      setState(() {
        _imageSize =
            widget.introState.currentBackgroundImage ==
                    "assets/images/background_image.png"
                ? _backgroundImageSize
                : _backgroundImage2Size;
        _applyLastTransformation();
      });
    }
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
    _rainTicker.stop();
    _rainTicker.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final introViewModel = context.read<IntroViewModel>();
    if (state == AppLifecycleState.paused) {
      introViewModel.add(PauseBackgroundMusicEvent());
      _rainTicker.stop();
    } else if (state == AppLifecycleState.resumed) {
      introViewModel.add(ResumeBackgroundMusicEvent());
      if (widget.introState.showRain) {
        _rainTicker.start();
      }
    }
  }

  Future<void> _loadAllImageSizes() async {
    try {
      _backgroundImageSize = await _loadImageSizeForPath(
        "assets/images/background_image.png",
      );
      _backgroundImage2Size = await _loadImageSizeForPath(
        "assets/images/background_image2.png",
      );
      setState(() {
        _imageSize =
            widget.introState.currentBackgroundImage ==
                    "assets/images/background_image.png"
                ? _backgroundImageSize
                : _backgroundImage2Size;
      });
    } catch (e) {
      context.read<IntroViewModel>().emit(
        widget.introState.copyWith(
          errorMessage: "Erro ao carregar tamanhos das imagens: $e",
        ),
      );
    }
  }

  Future<Size> _loadImageSizeForPath(String imagePath) async {
    final imageProvider = AssetImage(imagePath);
    final imageStream = imageProvider.resolve(ImageConfiguration());
    final completer = Completer<Size>();
    ImageStreamListener? listener;
    listener = ImageStreamListener(
      (ImageInfo info, bool synchronousCall) {
        completer.complete(
          Size(info.image.width.toDouble(), info.image.height.toDouble()),
        );
        imageStream.removeListener(listener!);
      },
      onError: (exception, stackTrace) {
        completer.completeError(exception, stackTrace);
      },
    );
    imageStream.addListener(listener);
    return await completer.future;
  }

  void _centerImage() {
    if (_imageSize == null || _screenSize == null) return;

    final double offsetX = (_screenSize!.width - _imageSize!.width) / 2;
    final double offsetY = (_screenSize!.height - _imageSize!.height) / 2;

    _transformationController.value =
        Matrix4.identity()..translate(offsetX, offsetY);
  }

  void _applyLastTransformation() {
    if (_lastTransformation == null ||
        _imageSize == null ||
        _screenSize == null) {
      _centerImage();
      return;
    }

    final oldImageSize =
        widget.introState.currentBackgroundImage ==
                "assets/images/background_image.png"
            ? _backgroundImage2Size
            : _backgroundImageSize;

    if (oldImageSize == null) {
      _centerImage();
      return;
    }

    final oldTranslation = _lastTransformation!.getTranslation();
    final double oldCenterX =
        (_screenSize!.width / 2 - oldTranslation.x) / oldImageSize.width;
    final double oldCenterY =
        (_screenSize!.height / 2 - oldTranslation.y) / oldImageSize.height;

    final double newTranslationX =
        _screenSize!.width / 2 - oldCenterX * _imageSize!.width;
    final double newTranslationY =
        _screenSize!.height / 2 - oldCenterY * _imageSize!.height;

    _transformationController.value =
        Matrix4.identity()..translate(newTranslationX, newTranslationY);
  }

  void _restrictMovement(ScaleUpdateDetails details) {
    if (_imageSize == null || _screenSize == null) return;

    final Matrix4 currentMatrix = _transformationController.value.clone();
    final translation = currentMatrix.getTranslation();

    final double maxX = 0.0;
    final double minX = _screenSize!.width - _imageSize!.width;
    final double maxY = 0.0;
    final double minY = _screenSize!.height - _imageSize!.height;

    double newX = translation.x.clamp(minX, maxX);
    double newY = translation.y.clamp(minY, maxY);

    if (newX != translation.x || newY != translation.y) {
      _transformationController.value =
          Matrix4.identity()..translate(newX, newY);
    }
  }

  void _handlePressHereTap() {
    debugPrint("Disparando StartGameEvent para tocar o som");
    context.read<IntroViewModel>().add(StartGameEvent());

    if (_isOpeningModal) return;

    if (widget.userName != "Conta") {
      widget.onStartGame();
      return;
    }

    setState(() {
      _isOpeningModal = true;
      _blinkCount = 0;
      _controller.clearStatusListeners();
    });

    _controller.stop();
    _controller.duration = const Duration(milliseconds: 200);
    _controller.repeat(reverse: true);

    void statusListener(AnimationStatus status) {
      if (status == AnimationStatus.reverse ||
          status == AnimationStatus.forward) {
        setState(() {
          _blinkCount++;
        });

        if (_blinkCount >= 6) {
          _controller.stop();
          _controller.duration = const Duration(seconds: 2);
          _controller.repeat(reverse: true);

          widget.onLogin().then((_) {
            if (mounted) {
              setState(() {
                _isOpeningModal = false;
                _blinkCount = 0;
                _controller.clearStatusListeners();
              });
              // Verificar se o usuário ainda não está logado
              if (widget.userName == "Conta") {
                debugPrint("Usuário não logou, resetando o som de press_here");
                context.read<IntroViewModel>().add(ResetPressHereSoundEvent());
              }
            }
          });

          _controller.removeStatusListener(statusListener);
        }
      }
    }

    _controller.addStatusListener(statusListener);
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    if (widget.introState.errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Ocorreu um erro: ${widget.introState.errorMessage}\nVerifique o log para detalhes.",
            style: const TextStyle(color: Colors.red, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (widget.introState.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_imageSize != null && _lastTransformation == null) {
      _centerImage();
    }

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child:
                _imageSize == null
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
                          if (duration <= _tapThreshold && !_isDragging) {
                            context.read<IntroViewModel>().add(
                              TapBackgroundEvent(),
                            );
                          }
                        }
                      },
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        constrained: false,
                        minScale: 1.0,
                        maxScale: 1.0,
                        onInteractionStart: (_) {
                          setState(() {
                            _isDragging = true;
                          });
                        },
                        onInteractionUpdate: (details) {
                          _restrictMovement(details);
                          _lastTransformation =
                              _transformationController.value.clone();
                        },
                        onInteractionEnd: (details) {
                          setState(() {
                            _isDragging = false;
                            _restrictMovement(ScaleUpdateDetails());
                            _lastTransformation =
                                _transformationController.value.clone();
                          });
                        },
                        child: SizedBox(
                          width: _imageSize!.width,
                          height: _imageSize!.height,
                          child: Image.asset(
                            widget.introState.currentBackgroundImage,
                            fit: BoxFit.cover,
                            width: _imageSize!.width,
                            height: _imageSize!.height,
                          ),
                        ),
                      ),
                    ),
          ),
          if (widget.introState.showRain)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: RainPainter(
                    drops: _rainDrops,
                    screenSize: _screenSize!,
                  ),
                  willChange: true,
                ),
              ),
            ),
          IgnorePointer(
            child: Align(
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
                      opacity: _logoOpacity,
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
          ),
          if (widget.introState.showFlash)
            IgnorePointer(
              child: FadeTransition(
                opacity: _flashOpacity,
                child: Center(
                  child: Image.asset(
                    widget.introState.currentLightning,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          if (widget.introState.showFlash)
            IgnorePointer(
              child: FadeTransition(
                opacity: _flashOpacity,
                child: Container(
                  color: Colors.white.withOpacity(0.5),
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: GestureDetector(
                onTap: _handlePressHereTap,
                behavior: HitTestBehavior.opaque,
                child: FadeTransition(
                  opacity: _pressHereOpacity,
                  child: FadeTransition(
                    opacity: _blinkOpacity,
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
          ),
        ],
      ),
    );
  }
}

class RainDrop {
  double x;
  double y;
  double speed;
  double length;

  RainDrop({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
  });
}

class RainPainter extends CustomPainter {
  final List<RainDrop> drops;
  final Size screenSize;

  RainPainter({required this.drops, required this.screenSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(0xB3E0F7FA)
          ..strokeWidth = 0.5
          ..style = PaintingStyle.stroke;

    for (var drop in drops) {
      double xPos = drop.x * screenSize.width;
      double yPos = drop.y * screenSize.height;
      double dropLength = drop.length;

      canvas.drawLine(
        Offset(xPos, yPos),
        Offset(xPos, yPos + dropLength),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

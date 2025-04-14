import 'package:flutter/material.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/views/pages/game_start_screen.dart';
import 'package:midnight_never_end/views/widgets/login_modal.dart';
import 'package:midnight_never_end/services/user/user_service.dart';
import 'dart:async';
import 'package:logger/logger.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // Logger
  final logger = Logger();

  // Controllers de animação
  late AnimationController _controller;
  late AnimationController _logoController;
  late AnimationController _pressHereController;
  late AnimationController _rainController;
  late Animation<double> _logoOpacity;
  late Animation<double> _flashOpacity;
  late Animation<double> _blinkOpacity;
  late Animation<double> _shineAnimation;
  late Animation<double> _pressHereOpacity;
  late Animation<double> _rainAnimation;

  // Estado da UI
  bool _showFlash = false;
  bool _isBlinkingFast = false;
  bool _showRain = false;
  String userName = "Conta";
  bool _logoFadeInCompleted = false;
  bool _pressHereFadeInCompleted = false;
  String _currentLightning = "assets/images/lightning.png";
  final List<String> _lightningImages = [
    "assets/images/lightning.png",
    "assets/images/lightning2.png",
    "assets/images/lightning3.png",
  ];
  final Random _random = Random();

  // Áudio
  final AudioPlayer _audioPlayer = AudioPlayer();
  final AudioPlayer _musicPlayer = AudioPlayer();
  bool _isMusicPlaying = false;
  bool _hasPlayedPressHereSound = false;

  // KeepAlive
  Timer? _keepAliveTimer;

  // Estado de erro
  bool _hasError = false;
  String _errorMessage = '';

  // Controle da imagem de fundo
  String _currentBackgroundImage = "assets/images/background_image.png";
  bool _hasChangedBackground = false;
  Size? _imageSize;
  Size? _backgroundImageSize;
  Size? _backgroundImage2Size;
  Size? _screenSize;
  bool _isDragging = false;
  final TransformationController _transformationController =
      TransformationController();

  // Partículas da chuva
  List<RainDrop> _rainDrops = [];
  final int _numberOfDrops = 100;

  // Controle de toque pra distinguir tap de arrastar
  DateTime? _tapDownTime;
  final Duration _tapThreshold = const Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    logger.d("Inicializando IntroScreen");

    try {
      WidgetsBinding.instance.addObserver(this);
      _initializeAnimations();
      _loadUser();
      _playBackgroundMusic();
      _pingBackend();
      _startKeepAlive();
      _loadAllImageSizes();
      _initializeRain();
    } catch (e, stackTrace) {
      _handleError("Erro no initState: $e", stackTrace);
    }
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

    _rainController = AnimationController(
      duration: const Duration(seconds: 10),
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

    _rainAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _rainController, curve: Curves.linear));

    _logoController.forward().then((_) {
      if (mounted) {
        logger.d("Fade-in do logo concluído");
        setState(() {
          _logoFadeInCompleted = true;
        });
      }
    });

    _pressHereController.forward().then((_) {
      if (mounted) {
        logger.d("Fade-in do texto PRESS HERE concluído");
        setState(() {
          _pressHereFadeInCompleted = true;
        });
      }
    });

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

    _rainController.addListener(() {
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
  }

  @override
  void dispose() {
    logger.d("Disposing IntroScreen");
    WidgetsBinding.instance.removeObserver(this);
    _keepAliveTimer?.cancel();
    _controller.stop();
    _controller.dispose();
    _logoController.stop();
    _logoController.dispose();
    _pressHereController.stop();
    _pressHereController.dispose();
    _rainController.stop();
    _rainController.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _musicPlayer.stop();
    _musicPlayer.dispose();
    _transformationController.dispose();
    logger.d("Música parada ao sair da IntroScreen");
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      if (_isMusicPlaying) {
        _musicPlayer.pause();
        logger.d("Música pausada ao minimizar o app");
      }
      _rainController.stop();
    } else if (state == AppLifecycleState.resumed) {
      if (_isMusicPlaying) {
        _musicPlayer.resume();
        logger.d("Música retomada ao voltar ao app");
      }
      if (_showRain) {
        _rainController.repeat();
        logger.d("Animação da chuva retomada");
      }
    }
  }

  void _loadUser() {
    try {
      if (mounted) {
        setState(() {
          userName = UserManager.currentUser?.nome ?? "Conta";
        });
      }
    } catch (e) {
      _handleError("Erro ao carregar usuário: $e");
    }
  }

  void _updateUser() {
    try {
      if (mounted) {
        setState(() {
          userName = UserManager.currentUser?.nome ?? "Conta";
        });
      }
    } catch (e) {
      _handleError("Erro ao atualizar usuário: $e");
    }
  }

  Future<void> _pingBackend() async {
    try {
      final stopwatch = Stopwatch()..start();
      await BackendPinger.pingBackend();
      stopwatch.stop();
      logger.d(
        "Ping inicial - Tempo total: ${stopwatch.elapsed.inMilliseconds / 1000} segundos",
      );
    } catch (e) {
      _handleError("Erro ao pingar o backend: $e");
    }
  }

  void _startKeepAlive() {
    try {
      _keepAliveTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
        if (mounted && UserManager.currentUser == null) {
          BackendPinger.pingBackend();
          logger.d("Keep-alive ping enviado em ${DateTime.now()}");
        } else {
          timer.cancel();
          logger.d("Keep-alive cancelado - Usuário logado ou tela descartada");
        }
      });
    } catch (e) {
      _handleError("Erro no _startKeepAlive: $e");
    }
  }

  void _handleTap() {
    if (!_showFlash && !_isBlinkingFast && mounted && !_isDragging) {
      logger.d("Toque detectado fora da área do texto - Iniciando flash");
      try {
        final currentTransform = _transformationController.value.clone();

        setState(() {
          _showFlash = true;
          _currentLightning =
              _lightningImages[_random.nextInt(_lightningImages.length)];
          if (!_hasChangedBackground) {
            _currentBackgroundImage = "assets/images/background_image2.png";
            _hasChangedBackground = true;
            _imageSize = _backgroundImage2Size;
            _showRain = true;
            logger.d("Chuva ativada: _showRain = $_showRain");
            _rainController.repeat();
            logger.d("Animação da chuva iniciada");
            _transformationController.value = currentTransform;
          }
        });

        _playThunderSound();
        _controller.stop();
        _controller.duration = const Duration(milliseconds: 200);
        _controller.reset();
        _controller.forward().then((_) {
          if (mounted) {
            logger.d("Flash terminado");
            setState(() {
              _showFlash = false;
            });
            _controller.duration = const Duration(seconds: 2);
            _controller.repeat(reverse: true);
          }
        });
      } catch (e, stackTrace) {
        _handleError("Erro no _handleTap: $e", stackTrace);
      }
    }
  }

  void _startGame() {
  if (!_isBlinkingFast && mounted && !_isDragging) {
    logger.d("Toque detectado no texto - Iniciando _startGame");
    try {
      if (!_hasPlayedPressHereSound) {
        _playPressHereSound();
        setState(() {
          _hasPlayedPressHereSound = true;
        });
      }

      setState(() {
        _isBlinkingFast = true;
      });
      _controller.stop();
      _controller.duration = const Duration(milliseconds: 200);
      _controller.repeat(reverse: true);

      Future.delayed(const Duration(seconds: 2), () async {
        if (mounted) {
          _controller.stop();
          setState(() {
            _isBlinkingFast = false;
          });

          if (UserManager.currentUser != null) {
            _musicPlayer.stop();
            _isMusicPlaying = false;
            logger.d("Usuário já logado - indo direto pra GameStartScreen");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GameStartScreen(),
              ),
            );
          } else {
            showLoginModal(context)
                .then((_) {
                  _updateUser();
                  if (mounted) {
                    if (UserManager.currentUser != null) {
                      _musicPlayer.stop();
                      _isMusicPlaying = false;
                      logger.d("Música parada antes de ir pra GameStartScreen");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameStartScreen(),
                        ),
                      );
                    } else {
                      setState(() {
                        _hasPlayedPressHereSound = false;
                        logger.d("Usuário voltou sem logar");
                      });
                    }
                  }
                })
                .catchError((e) {
                  logger.e("Erro ao abrir LoginModal: $e");
                  if (mounted) {
                    setState(() {
                      _hasPlayedPressHereSound = false;
                      _controller.duration = const Duration(seconds: 2);
                      _controller.repeat(reverse: true);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Erro ao abrir login: $e"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                });
          }
        }
      });
    } catch (e, stackTrace) {
      _handleError("Erro no _startGame: $e", stackTrace);
    }
  }
}


  Future<void> _playThunderSound() async {
    try {
      logger.d("Tentando tocar o trovão...");
      await _audioPlayer.stop();
      await _audioPlayer.setSource(AssetSource('audios/thunder.wav'));
      await _audioPlayer.resume();
      logger.d("Trovão tocado com sucesso");
    } catch (e, stackTrace) {
      _handleError("Erro ao tocar trovão: $e", stackTrace);
    }
  }

  Future<void> _playPressHereSound() async {
    try {
      logger.d("Tentando tocar o som de press_here...");
      await _audioPlayer.stop();
      await _audioPlayer.setSource(AssetSource('audios/press_here.wav'));
      await _audioPlayer.resume();
      logger.d("Som de press_here tocado com sucesso");
    } catch (e, stackTrace) {
      _handleError("Erro ao tocar press_here: $e", stackTrace);
    }
  }

  Future<void> _playBackgroundMusic() async {
    try {
      logger.d("Tentando tocar música de fundo...");
      await _musicPlayer.setSource(AssetSource('audios/sons_of_liberty.mp3'));
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.5);
      await _musicPlayer.resume();
      setState(() {
        _isMusicPlaying = true;
      });
      logger.d("Música iniciada: sons_of_liberty.mp3");
    } catch (e, stackTrace) {
      _handleError("Erro ao tocar música: $e", stackTrace);
    }
  }

  void _handleError(String message, [StackTrace? stackTrace]) {
    logger.e("$message\n${stackTrace ?? ''}");
    setState(() {
      _hasError = true;
      _errorMessage = message;
    });
  }

  Future<void> _loadAllImageSizes() async {
    try {
      _backgroundImageSize = await _loadImageSizeForPath(
        "assets/images/background_image.png",
      );
      logger.d(
        "Tamanho da background_image carregado: ${_backgroundImageSize!.width}x${_backgroundImageSize!.height}",
      );

      _backgroundImage2Size = await _loadImageSizeForPath(
        "assets/images/background_image2.png",
      );
      logger.d(
        "Tamanho da background_image2 carregado: ${_backgroundImage2Size!.width}x${_backgroundImage2Size!.height}",
      );

      setState(() {
        _imageSize = _backgroundImageSize;
        _centerImage();
      });
    } catch (e, stackTrace) {
      _handleError("Erro ao carregar tamanhos das imagens: $e", stackTrace);
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

    logger.d(
      "Imagem centralizada com deslocamento: offsetX=$offsetX, offsetY=$offsetY, imageSize=${_imageSize!.width}x${_imageSize!.height}",
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Ocorreu um erro: $_errorMessage\nVerifique o log para detalhes.",
            style: const TextStyle(color: Colors.red, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    _screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // Imagem de fundo com InteractiveViewer
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
                          if (duration <= _tapThreshold) {
                            _handleTap();
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
                          logger.d("Início do arrastar da imagem de fundo");
                        },
                        onInteractionEnd: (_) {
                          setState(() {
                            _isDragging = false;
                          });
                          logger.d("Fim do arrastar da imagem de fundo");
                        },
                        child: SizedBox(
                          width: _imageSize!.width,
                          height: _imageSize!.height,
                          child: Image.asset(
                            _currentBackgroundImage,
                            fit: BoxFit.cover,
                            width: _imageSize!.width,
                            height: _imageSize!.height,
                          ),
                        ),
                      ),
                    ),
          ),
          // Animação de chuva (acima da imagem, mas não bloqueia gestos)
          if (_showRain)
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
          // Logo mais acima (estilo Night of the Full Moon)
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
                        _logoFadeInCompleted
                            ? const AlwaysStoppedAnimation(1.0)
                            : _logoOpacity,
                    child: Image.asset(
                      "assets/images/logo_image.png",
                      width: 300,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            ),
          ),
          // Flash do trovão
          if (_showFlash)
            FadeTransition(
              opacity: _flashOpacity,
              child: Center(
                child: Image.asset(
                  _currentLightning,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (_showFlash)
            FadeTransition(
              opacity: _flashOpacity,
              child: Container(
                color: Colors.white.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          // Texto "- PRESS HERE -" com fonte Kirsty e letra menor
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: GestureDetector(
                onTap: _startGame,
                behavior: HitTestBehavior.opaque,
                child: FadeTransition(
                  opacity:
                      _pressHereFadeInCompleted
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
  final logger = Logger();

  RainPainter({required this.drops, required this.screenSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = const Color(
            0xB3E0F7FA,
          ) // Cor gelo com 70% de opacidade (alpha = 179)
          ..strokeWidth =
              0.5 // Pingos finos
          ..style = PaintingStyle.stroke;

    int dropsDrawn = 0;
    for (var drop in drops) {
      double xPos = drop.x * screenSize.width;
      double yPos = drop.y * screenSize.height;
      double dropLength = drop.length;

      canvas.drawLine(
        Offset(xPos, yPos),
        Offset(xPos, yPos + dropLength),
        paint,
      );
      dropsDrawn++;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

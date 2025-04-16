import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/views/widgets/habilidades_modal.dart';
import 'package:midnight_never_end/views/widgets/opcoes_conta.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';

class GameStartScreen extends StatefulWidget {
  const GameStartScreen({super.key});

  @override
  _GameStartScreenState createState() => _GameStartScreenState();
}

class _GameStartScreenState extends State<GameStartScreen>
    with TickerProviderStateMixin {
  bool _isLayoutReady = false;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AudioPlayer _audioPlayer; // Para sons de efeitos
  late AudioPlayer _backgroundAudioPlayer; // Para música de fundo
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _backgroundAudioPlayer = AudioPlayer();
    _preloadSounds();

    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Iniciar a música de fundo
    _playBackgroundMusic();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await _precacheImages(context);
        setState(() {
          _isLayoutReady = true;
          if (kDebugMode) logger.d("Layout pronto: $_isLayoutReady");
        });
      }
    });
  }

  Future<void> _preloadSounds() async {
    try {
      await _audioPlayer.setVolume(0.5);
      await _audioPlayer.setSource(AssetSource('audios/woosh.mp3'));
      await _audioPlayer.setSource(AssetSource('audios/tec.wav'));
      await _audioPlayer.setSource(AssetSource('audios/pop.wav'));

      // Pré-carregar a música de fundo
      await _backgroundAudioPlayer.setVolume(
        0.3,
      ); // Volume mais baixo pra música de fundo
      await _backgroundAudioPlayer.setSource(
        AssetSource('audios/game_background.mp3'),
      );
      if (kDebugMode)
        logger.d("Sons e música de fundo pré-carregados com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao pré-carregar sons: $e\n$stackTrace");
    }
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _backgroundAudioPlayer.setReleaseMode(
        ReleaseMode.loop,
      ); // Configurar pra tocar em loop
      await _backgroundAudioPlayer.play(
        AssetSource('audios/game_background.mp3'),
      );
      if (kDebugMode) logger.d("Música de fundo iniciada");
    } catch (e, stackTrace) {
      if (kDebugMode)
        logger.e("Erro ao tocar música de fundo: $e\n$stackTrace");
    }
  }

  Future<void> _precacheImages(BuildContext context) async {
    try {
      for (int i = 1; i <= 5; i++) {
        await precacheImage(
          AssetImage("assets/images/mini_dungeons/dungeon_$i.png"),
          context,
        );
      }
      await precacheImage(
        AssetImage("assets/images/game_background.png"),
        context,
      );
      await precacheImage(AssetImage("assets/icons/permCoin.png"), context);
      if (kDebugMode) logger.d("Imagens pré-carregadas com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao pré-carregar imagens: $e\n$stackTrace");
    }
  }

  Future<void> _playScrollSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audios/woosh.mp3'));
      if (kDebugMode) logger.d("Som de scroll tocado");
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao tocar som de scroll: $e\n$stackTrace");
    }
  }

  Future<void> _playClickSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audios/tec.wav'));
      if (kDebugMode) logger.d("Som de clique tocado");
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao tocar som de clique: $e\n$stackTrace");
    }
  }

  Future<void> _playDungeonSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audios/pop.wav'));
      if (kDebugMode) logger.d("Som da dungeon tocado");
    } catch (e, stackTrace) {
      if (kDebugMode) logger.e("Erro ao tocar som da dungeon: $e\n$stackTrace");
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    _backgroundAudioPlayer.stop(); // Parar a música de fundo
    _backgroundAudioPlayer.dispose();
    super.dispose();
    if (kDebugMode) logger.d("GameStartScreen descartado");
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  void _startAdventure(int index) {
    if (_isLayoutReady && mounted) {
      _playDungeonSound();
      final adventures = [
        {
          "title": "A Cidade Sombria",
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
      final bool isLocked = adventures[index]["locked"] as bool;

      if (isLocked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Esta aventura está bloqueada!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        if (kDebugMode) logger.d("Iniciando aventura ${index + 1}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Iniciando aventura ${index + 1}..."),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _openAccountOptions() {
    if (mounted) {
      _playClickSound();
      showAccountOptions(
        context,
        UserManager.currentUser?.nome ?? "Usuário",
        _updateState,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/game_background.png"),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        GlowingIcon(
                          icon: Icons.arrow_back,
                          size: 24,
                          onPressed: _openAccountOptions,
                          tooltip: "Opções da Conta",
                          glowAnimation: _glowAnimation,
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _openAccountOptions,
                          child: Text(
                            (UserManager.currentUser?.nome ?? "Usuário")
                                .toUpperCase(),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cinzel",
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${UserManager.currentUser?.moedaPermanente?.quantidade ?? 0}',
                          style: const TextStyle(
                            fontFamily: "Cinzel",
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/icons/permCoin.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                          color: Colors.cyanAccent,
                        ),
                      ],
                    ),
                  ],
                ),
                Expanded(
                  child:
                      _isLayoutReady
                          ? AdventureCarousel(
                            glowAnimation: _glowAnimation,
                            onAdventureTap: _startAdventure,
                            playScrollSound: _playScrollSound,
                          )
                          : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                ),
                Container(
                  height: 60,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GlowingIcon(
                        icon: Icons.star,
                        size: 30,
                        onPressed: () {
                          if (mounted) {
                            _playClickSound();
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => const HabilidadesWidget(),
                            ).whenComplete(() {
                              _updateState();
                            });
                          }
                        },
                        tooltip: "Habilidades",
                        glowAnimation: _glowAnimation,
                      ),
                      GlowingIcon(
                        icon: Icons.settings,
                        size: 30,
                        onPressed: () {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Configurações em breve!"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        tooltip: "Configurações",
                        glowAnimation: _glowAnimation,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AdventureCarousel extends StatefulWidget {
  final Animation<double> glowAnimation;
  final Function(int) onAdventureTap;
  final Function() playScrollSound;

  const AdventureCarousel({
    super.key,
    required this.glowAnimation,
    required this.onAdventureTap,
    required this.playScrollSound,
  });

  @override
  _AdventureCarouselState createState() => _AdventureCarouselState();
}

class _AdventureCarouselState extends State<AdventureCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  double _currentPageValue = 0.0;
  double _dragStartPosition = 0.0;
  double _dragDelta = 0.0;
  int _lastPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final newPageValue = _pageController.page ?? 0.0;
      final newPage = newPageValue.round();

      if ((_currentPageValue - newPageValue).abs() > 0.01) {
        setState(() {
          _currentPageValue = newPageValue;
        });
      }

      if (_pageController.position.haveDimensions &&
          (_currentPageValue - newPage).abs() < 0.1 &&
          newPage != _lastPage) {
        _lastPage = newPage;
        widget.playScrollSound();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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

    void _onDragStart(DragStartDetails details) {
      _dragStartPosition = _currentPageValue;
      _dragDelta = 0.0;
    }

    void _onDragUpdate(DragUpdateDetails details) {
      _dragDelta += details.primaryDelta! / context.size!.width * 5;
      final newPosition = _dragStartPosition - _dragDelta;
      final pageWidth = context.size!.width * 0.85;
      _pageController.jumpTo(newPosition * pageWidth);
    }

    void _onDragEnd(DragEndDetails details) {
      final newPage = _currentPageValue.round();
      _pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    Widget carousel = PageView.builder(
      controller: _pageController,
      physics: const ClampingScrollPhysics(),
      itemCount: adventures.length,
      itemBuilder: (context, index) {
        final adventure = adventures[index];
        final bool isLocked = adventure["locked"] as bool;

        final double pageOffset = (_currentPageValue - index).abs();
        final double scale = (1.0 - (pageOffset * 0.1)).clamp(0.9, 1.0);
        final double opacity = (1.0 - (pageOffset * 0.3)).clamp(0.7, 1.0);

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: () => widget.onAdventureTap(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(
                      widget.glowAnimation.value * 0.5,
                    ),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "assets/images/mini_dungeons/dungeon_${index + 1}.png",
                          fit: BoxFit.cover,
                          color: isLocked ? Colors.grey.withOpacity(0.5) : null,
                          colorBlendMode:
                              isLocked ? BlendMode.saturation : null,
                          errorBuilder:
                              (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      if (isLocked)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          color: Colors.black.withOpacity(0.7),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                adventure["title"] as String,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isLocked ? Colors.grey : Colors.white,
                                  fontFamily: "Cinzel",
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                adventure["desc"] as String,
                                style: TextStyle(
                                  fontSize: 14,
                                  color:
                                      isLocked ? Colors.grey : Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (isLocked)
                        const Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Icon(
                              Icons.lock,
                              color: Colors.grey,
                              size: 48,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    if (kIsWeb) {
      carousel = GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        child: carousel,
      );
    }

    return Column(
      children: [
        Expanded(child: carousel),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(adventures.length, (index) {
            final double pageOffset = (_currentPageValue - index).abs();
            final double size = (12.0 - (pageOffset * 4.0)).clamp(8.0, 12.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    pageOffset < 0.5
                        ? Colors.cyanAccent
                        : Colors.grey.withOpacity(0.5),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class GlowingIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onPressed;
  final String tooltip;
  final Animation<double> glowAnimation;

  const GlowingIcon({
    super.key,
    required this.icon,
    required this.size,
    required this.onPressed,
    required this.tooltip,
    required this.glowAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: AnimatedBuilder(
        animation: glowAnimation,
        builder: (context, child) {
          return Icon(
            icon,
            size: size,
            color: Colors.cyanAccent.withOpacity(glowAnimation.value),
          );
        },
      ),
    );
  }
}

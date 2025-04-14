import 'package:flutter/material.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/views/widgets/habilidades_modal.dart';
import 'package:midnight_never_end/views/widgets/opcoes_conta.dart';
import 'package:audioplayers/audioplayers.dart';

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
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    // Inicializar o AudioPlayer
    _audioPlayer = AudioPlayer();
    _preloadSounds();

    // Inicializar o AnimationController pro efeito de brilho
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _pageController.addListener(() {
      final newPage = _pageController.page?.round() ?? 0;
      if (newPage != _currentPage) {
        // Tocar som quando a página muda
        _playScrollSound();
        setState(() {
          _currentPage = newPage;
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isLayoutReady = true;
          print("Layout pronto: $_isLayoutReady");
        });
      }
    });
  }

  // Pré-carregar os sons
  Future<void> _preloadSounds() async {
    try {
      await _audioPlayer.setSource(AssetSource('audios/woosh.mp3'));
      await _audioPlayer.setSource(AssetSource('audios/tec.wav'));
      await _audioPlayer.setSource(AssetSource('audios/pop.wav'));
      await _audioPlayer.setVolume(0.5);
      print("Sons pré-carregados com sucesso");
    } catch (e) {
      print("Erro ao pré-carregar sons: $e");
    }
  }

  // Função para tocar o som do carrossel
  Future<void> _playScrollSound() async {
    try {
      await _audioPlayer.play(AssetSource('audios/woosh.mp3'));
      await _audioPlayer.setVolume(0.5);
    } catch (e) {
      print("Erro ao tocar som de scroll: $e");
    }
  }

  // Função para tocar o som de clique (voltar e habilidades)
  Future<void> _playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('audios/tec.wav'));
      await _audioPlayer.setVolume(0.5);
    } catch (e) {
      print("Erro ao tocar som de clique: $e");
    }
  }

  // Função para tocar o som da dungeon
  Future<void> _playDungeonSound() async {
    try {
      await _audioPlayer.play(AssetSource('audios/pop.wav'));
      await _audioPlayer.setVolume(0.5);
    } catch (e) {
      print("Erro ao tocar som da dungeon: $e");
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _updateState() {
    if (mounted) {
      setState(() {});
    }
  }

  void _startAdventure(int index) {
    if (_isLayoutReady && mounted) {
      _playDungeonSound(); // Toca o som ao clicar na dungeon
      final adventures = [
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
        print("Iniciando aventura ${index + 1}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Iniciando aventura ${index + 1}..."),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        // Adicione aqui a lógica pra iniciar a aventura
      }
    }
  }

  void _openAccountOptions() {
    if (mounted) {
      _playClickSound(); // Toca o som ao clicar
      showAccountOptions(
        context,
        UserManager.currentUser?.nome ?? "Usuário",
        _updateState,
      );
    }
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
                          child: AnimatedBuilder(
                            animation: _glowAnimation,
                            builder: (context, child) {
                              return Text(
                                (UserManager.currentUser?.nome ?? "Usuário")
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Cinzel",
                                  shadows: [
                                    Shadow(
                                      blurRadius: 10.0 * _glowAnimation.value,
                                      color: Colors.cyanAccent,
                                      offset: const Offset(0, 0),
                                    ),
                                    Shadow(
                                      blurRadius: 5.0 * _glowAnimation.value,
                                      color: Colors.white,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              );
                            },
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
                            shadows: [
                              Shadow(
                                blurRadius: 8.0,
                                color: Colors.cyanAccent,
                                offset: Offset(0, 0),
                              ),
                              Shadow(
                                blurRadius: 4.0,
                                color: Colors.white,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/icons/permCoin.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "Midnight Never End",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Cinzel",
                      shadows: [
                        Shadow(
                          blurRadius: 10.0,
                          color: Colors.cyanAccent,
                          offset: Offset(0, 0),
                        ),
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.white,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: _isLayoutReady
                      ? Column(
                          children: [
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: adventures.length,
                                itemBuilder: (context, index) {
                                  final adventure = adventures[index];
                                  final bool isLocked =
                                      adventure["locked"] as bool;
                                  final double scale = _currentPage == index
                                      ? 1.0
                                      : 0.9; // Escala maior pra dungeon atual
                                  return Transform.scale(
                                    scale: scale,
                                    child: GestureDetector(
                                      onTap: () => _startAdventure(index),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 20,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.cyanAccent
                                                  .withOpacity(
                                                      _glowAnimation.value * 0.5),
                                              blurRadius:
                                                  10.0 * _glowAnimation.value,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Stack(
                                            children: [
                                              // Imagem ocupando todo o card
                                              Positioned.fill(
                                                child: Image.asset(
                                                  "assets/images/mini_dungeons/dungeon_${index + 1}.png",
                                                  fit: BoxFit.cover,
                                                  color: isLocked
                                                      ? Colors.grey
                                                          .withOpacity(0.5)
                                                      : null,
                                                  colorBlendMode: isLocked
                                                      ? BlendMode.saturation
                                                      : null,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                      Icons.image_not_supported,
                                                      size: 60,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              // Sombra para dungeons bloqueadas
                                              if (isLocked)
                                                Positioned.fill(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        colors: [
                                                          Colors.black
                                                              .withOpacity(0.7),
                                                          Colors.black
                                                              .withOpacity(0.3),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              // Conteúdo do card
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  width: double.infinity,
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topCenter,
                                                      end: Alignment.bottomCenter,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                            .withOpacity(0.7),
                                                      ],
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisSize: MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        adventure["title"]
                                                            as String,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: isLocked
                                                              ? Colors.grey
                                                              : Colors.white,
                                                          fontFamily: "Cinzel",
                                                          shadows: isLocked
                                                              ? []
                                                              : [
                                                                  Shadow(
                                                                    blurRadius:
                                                                        10.0 *
                                                                            _glowAnimation
                                                                                .value,
                                                                    color: Colors
                                                                        .cyanAccent,
                                                                    offset:
                                                                        const Offset(
                                                                            0, 0),
                                                                  ),
                                                                ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        adventure["desc"]
                                                            as String,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          color: isLocked
                                                              ? Colors.grey
                                                              : Colors.white70,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              // Ícone de cadeado no centro se estiver bloqueado
                                              if (isLocked)
                                                Positioned(
                                                  top: 0,
                                                  bottom: 0,
                                                  left: 0,
                                                  right: 0,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.lock,
                                                      color: Colors.grey[300],
                                                      size: 48,
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Indicadores de página (dots)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                adventures.length,
                                (index) => Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  width: _currentPage == index ? 12 : 8,
                                  height: _currentPage == index ? 12 : 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentPage == index
                                        ? Colors.cyanAccent
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
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
                            _playClickSound(); // Toca o som ao clicar
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

// Widget customizado pra ícones com efeito de brilho
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
          return Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: size,
                color: Colors.cyanAccent.withOpacity(glowAnimation.value * 0.5),
                shadows: [
                  Shadow(
                    blurRadius: 10.0 * glowAnimation.value,
                    color: Colors.cyanAccent,
                    offset: const Offset(0, 0),
                  ),
                  Shadow(
                    blurRadius: 5.0 * glowAnimation.value,
                    color: Colors.white,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.5),
                      Colors.cyanAccent.withOpacity(glowAnimation.value),
                      Colors.white.withOpacity(0.5),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ).createShader(bounds);
                },
                blendMode: BlendMode.srcATop,
                child: Icon(icon, size: size, color: Colors.white),
              ),
            ],
          );
        },
      ),
    );
  }
}
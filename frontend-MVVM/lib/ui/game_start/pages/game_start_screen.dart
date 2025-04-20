import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/core/library/overlay_notification.dart';
import 'package:midnight_never_end/ui/game_start/view_models/game_start_bloc.dart';
import 'package:midnight_never_end/ui/habilidades/pages/habilidades_moda.dart';
import 'package:midnight_never_end/ui/opcoes_conta/pages/opcoes_conta.dart';
import 'package:audioplayers/audioplayers.dart';

class GameStartScreen extends StatelessWidget {
  const GameStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => GameStartBloc(
            audioPlayer: AudioPlayer(),
            backgroundAudioPlayer: AudioPlayer(),
          ),
      child: const GameStartScreenContent(),
    );
  }
}

class GameStartScreenContent extends StatefulWidget {
  const GameStartScreenContent({super.key});

  @override
  _GameStartScreenContentState createState() => _GameStartScreenContentState();
}

class _GameStartScreenContentState extends State<GameStartScreenContent>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Pré-carregar imagens após o layout estar pronto
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _precacheImages(context);
      if (mounted) {
        setState(() {});
      }
    });
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
      if (kDebugMode) print("Imagens pré-carregadas com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode) print("Erro ao pré-carregar imagens: $e\n$stackTrace");
    }
  }

  void _updateState() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameStartBloc, GameStartState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          OverlayNotification.show(
            context: context,
            message: state.errorMessage!,
            backgroundColor:
                state.errorMessage!.contains("bloqueada") ||
                        state.errorMessage!.contains("em breve")
                    ? Colors.redAccent
                    : Colors.green,
            duration: const Duration(seconds: 2),
          );
        }
      },
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

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Container(
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
                                  icon:
                                      Icons
                                          .account_circle, // Alterado para ícone mais intuitivo
                                  size: 24,
                                  onPressed: () {
                                    context.read<GameStartBloc>().add(
                                      OpenAccountOptionsEvent(),
                                    );
                                    showAccountOptions(
                                      context,
                                      state.userName,
                                      _updateState,
                                    );
                                  },
                                  tooltip: "Opções da Conta",
                                  glowAnimation: _glowAnimation,
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    context.read<GameStartBloc>().add(
                                      OpenAccountOptionsEvent(),
                                    );
                                    showAccountOptions(
                                      context,
                                      state.userName,
                                      _updateState,
                                    );
                                  },
                                  child: Text(
                                    state.userName.toUpperCase(),
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
                                  '${state.coinAmount}',
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
                                  width: 55,
                                  height: 55,
                                  fit: BoxFit.contain,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child:
                              state.isLayoutReady
                                  ? GestureDetector(
                                    onTap: () {
                                      if (!state.isAudioEnabled) {
                                        context.read<GameStartBloc>().add(
                                          EnableAudioEvent(),
                                        );
                                      }
                                    },
                                    child: AdventureCarousel(
                                      glowAnimation: _glowAnimation,
                                      onAdventureTap: (index) {
                                        context.read<GameStartBloc>().add(
                                          AdventureTappedEvent(index),
                                        );
                                      },
                                      onScrollChanged: (pageValue) {
                                        context.read<GameStartBloc>().add(
                                          ScrollChangedEvent(pageValue),
                                        );
                                      },
                                      adventures: state.adventures,
                                      currentPageValue: state.currentPageValue,
                                      lastPage: state.lastPage,
                                    ),
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
                                  context.read<GameStartBloc>().add(
                                    OpenHabilidadesEvent(),
                                  );
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder:
                                        (context) => const HabilidadesWidget(),
                                  ).whenComplete(() {
                                    _updateState();
                                  });
                                },
                                tooltip: "Habilidades",
                                glowAnimation: _glowAnimation,
                              ),
                              GlowingIcon(
                                icon: Icons.settings,
                                size: 30,
                                onPressed: () {
                                  context.read<GameStartBloc>().add(
                                    OpenSettingsEvent(),
                                  );
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
              if (state.showAudioPrompt)
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
            ],
          ),
        );
      },
    );
  }
}

class AdventureCarousel extends StatelessWidget {
  final Animation<double> glowAnimation;
  final Function(int) onAdventureTap;
  final Function(double) onScrollChanged;
  final List<Map<String, dynamic>> adventures;
  final double currentPageValue;
  final int lastPage;

  const AdventureCarousel({
    super.key,
    required this.glowAnimation,
    required this.onAdventureTap,
    required this.onScrollChanged,
    required this.adventures,
    required this.currentPageValue,
    required this.lastPage,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController(
      viewportFraction: 0.85,
    );

    // Listener para atualizar o estado do carrossel
    pageController.addListener(() {
      final newPageValue = pageController.page ?? 0.0;
      onScrollChanged(newPageValue);
    });

    void onDragStart(DragStartDetails details) {
      // Não é necessário armazenar o estado aqui, já que o Bloc gerencia
    }

    void onDragUpdate(DragUpdateDetails details) {
      final newPosition =
          pageController.page! -
          (details.primaryDelta! / context.size!.width * 5);
      final pageWidth = context.size!.width * 0.85;
      pageController.jumpTo(newPosition * pageWidth);
    }

    void onDragEnd(DragEndDetails details) {
      final newPage = currentPageValue.round();
      pageController.animateToPage(
        newPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }

    Widget carousel = PageView.builder(
      controller: pageController,
      physics: const ClampingScrollPhysics(),
      itemCount: adventures.length,
      itemBuilder: (context, index) {
        final adventure = adventures[index];
        final bool isLocked = adventure["locked"] as bool;

        final double pageOffset = (currentPageValue - index).abs();
        final double scale = (1.0 - (pageOffset * 0.1)).clamp(0.9, 1.0);
        final double opacity = (1.0 - (pageOffset * 0.3)).clamp(0.7, 1.0);

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: GestureDetector(
              onTap: () => onAdventureTap(index),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(
                      glowAnimation.value * 0.5,
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
        onHorizontalDragStart: onDragStart,
        onHorizontalDragUpdate: onDragUpdate,
        onHorizontalDragEnd: onDragEnd,
        child: carousel,
      );
    }

    return Column(
      children: [
        Expanded(child: carousel),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(adventures.length, (index) {
            final double pageOffset = (currentPageValue - index).abs();
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

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:midnight_never_end/core/library/overlay_notification.dart';
import 'package:midnight_never_end/ui/habilidades/pages/talent_tile.dart';
import 'package:midnight_never_end/ui/habilidades/view_models/habilidade_bloc.dart';

class HabilidadesWidget extends StatelessWidget {
  const HabilidadesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabilidadesBloc(audioPlayer: AudioPlayer()),
      child: const HabilidadesContent(),
    );
  }
}

class HabilidadesContent extends StatefulWidget {
  const HabilidadesContent({super.key});

  @override
  State<HabilidadesContent> createState() => _HabilidadesContentState();
}

class _HabilidadesContentState extends State<HabilidadesContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final logger = Logger();
  bool _resourcesPreloaded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_resourcesPreloaded) {
      _preloadResources();
      _resourcesPreloaded = true;
    }
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
    if (kDebugMode) logger.d("HabilidadesWidget descartado");
  }

  Future<void> _preloadResources() async {
    try {
      await precacheImage(AssetImage("assets/icons/permCoin.png"), context);
      if (kDebugMode) logger.d("Recursos pré-carregados com sucesso");
    } catch (e, stackTrace) {
      if (kDebugMode)
        logger.e("Erro ao pré-carregar recursos: $e\n$stackTrace");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HabilidadesBloc, HabilidadesState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          OverlayNotification.show(
            context: context,
            message: state.errorMessage!,
            backgroundColor:
                state.errorMessage!.contains("insuficientes")
                    ? Colors.redAccent
                    : Colors.green,
            duration: const Duration(seconds: 2),
          );

          if (state.errorMessage!.contains("insuficientes")) {
            showDialog(
              context: context,
              builder: (BuildContext dialogContext) {
                return const InsufficientCoinsDialog();
              },
            );
          }
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.cyanAccent),
          );
        }

        return DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.5,
          maxChildSize: 1,
          builder: (context, scrollController) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  border: Border.all(
                    color: Colors.cyanAccent.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: Stack(
                  children: [
                    ListView.builder(
                      controller: scrollController,
                      physics: const ClampingScrollPhysics(),
                      itemCount: state.talents.length + 2,
                      itemBuilder: (context, index) {
                        if (index == 0) return _buildHeader();
                        if (index == 1) return _buildCoinDisplay(state.coins);
                        final talentIndex = index - 2;
                        final talent = state.talents[talentIndex];
                        return TalentTile(
                          icon: talent["icon"],
                          title: talent["title"],
                          level: talent["level"],
                          cost: talent["cost"],
                          onPressed:
                              () => context.read<HabilidadesBloc>().add(
                                UpgradeTalentEvent(talentIndex),
                              ),
                          glowAnimation: null,
                        );
                      },
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Center(
          child: Text(
            "TALENTOS",
            style: TextStyle(
              fontFamily: "Cinzel",
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        SizedBox(height: 8),
        Center(
          child: Text(
            "Talentos podem fazer com que você\nfique mais forte permanentemente!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Cinzel",
              fontSize: 16,
              color: Colors.cyanAccent,
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildCoinDisplay(int coins) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/icons/permCoin.png',
          width: 40,
          height: 40,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 10),
        Text(
          '$coins',
          style: const TextStyle(
            fontFamily: "Cinzel",
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
      ],
    );
  }
}

class InsufficientCoinsDialog extends StatefulWidget {
  const InsufficientCoinsDialog({super.key});

  @override
  _InsufficientCoinsDialogState createState() =>
      _InsufficientCoinsDialogState();
}

class _InsufficientCoinsDialogState extends State<InsufficientCoinsDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
    if (kDebugMode) logger.d("InsufficientCoinsDialog descartado");
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        content: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "MOEDAS INSUFICIENTES!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                  fontFamily: "Cinzel",
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "OK",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: "Cinzel",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

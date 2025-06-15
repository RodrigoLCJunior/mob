import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:midnight_never_end/ui/login/pages/login_modal.dart';
import '../view_model/intro_view_model.dart';
import '../../../domain/entities/intro/intro_entity.dart';
import '../widgets/intro_background.dart';
import '../widgets/intro_flash.dart';
import '../widgets/intro_logo.dart';
import '../widgets/intro_press_here.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  late final TransformationController _controller;
  late AnimationController _logoController;
  late Animation<double> _logoOpacity;
  late AnimationController _flashController;
  late Animation<double> _flashOpacity;
  late AnimationController _pressHereController;
  late Animation<double> _pressHereBlinkOpacity;
  late AnimationController _pressHereFastBlinkController;
  late Animation<double> _pressHereFastBlinkOpacity;

  final AudioPlayer _audioPlayer = AudioPlayer(); // Efeitos
  final AudioPlayer _bgmPlayer = AudioPlayer(); // Música de fundo

  bool _isFastBlinking = false;
  bool _bgmStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = TransformationController();

    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));
    _logoController.forward();

    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _flashOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_flashController)..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.read<IntroViewModel>().resetFlash();
        _flashController.reset();
      }
    });

    _pressHereController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _pressHereBlinkOpacity = Tween<double>(
      begin: 0.15,
      end: 1.0,
    ).animate(_pressHereController);

    _pressHereFastBlinkController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pressHereFastBlinkOpacity = Tween<double>(
      begin: 0.15,
      end: 1.0,
    ).animate(_pressHereFastBlinkController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<IntroViewModel>();
      vm.ensureInitialImageSize();
      _controller.value = vm.state.transformationMatrix;
      _controller.addListener(_onPanZoomChanged);
      // NÃO tocar música aqui! O navegador web só permite após interação do usuário!
    });
  }

  void _onPanZoomChanged() {
    context.read<IntroViewModel>().setTransformationMatrix(_controller.value);
  }

  @override
  void dispose() {
    _controller.removeListener(_onPanZoomChanged);
    _controller.dispose();
    _logoController.dispose();
    _flashController.dispose();
    _pressHereController.dispose();
    _pressHereFastBlinkController.dispose();
    _audioPlayer.dispose();
    _bgmPlayer.dispose();
    super.dispose();
  }

  Future<void> _playThunderSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(AssetSource('audios/thunder.wav'));
      await _audioPlayer.resume();
    } catch (_) {}
  }

  Future<void> _playPressHereSound() async {
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(AssetSource('audios/press_here.wav'));
      await _audioPlayer.resume();
    } catch (_) {}
  }

  Future<void> _playBackgroundMusicIfNeeded() async {
    if (!_bgmStarted) {
      _bgmStarted = true;
      try {
        await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
        await _bgmPlayer.setSource(AssetSource('audios/sons_of_liberty.mp3'));
        await _bgmPlayer.resume();
      } catch (_) {}
    }
  }

  void _onTap() async {
    await _playBackgroundMusicIfNeeded(); // Ativa BGM no primeiro clique do usuário
    if (_isFastBlinking) return;
    final vm = context.read<IntroViewModel>();
    if (!vm.state.hasChangedBackground) {
      await vm.triggerThunderAndChangeBackground();
    } else {
      await vm.triggerThunderOnly();
    }
    _flashController.forward(from: 0.0);
    _playThunderSound();
  }

  void _onPressHereTap() async {
    await _playBackgroundMusicIfNeeded();
    await _playPressHereSound();

    // Piscar rápido 3 vezes, 150ms cada piscada
    await context.read<IntroViewModel>().startFastBlinkingNTimes(
      3,
      const Duration(milliseconds: 150),
    );

    // Chama o modal de login de forma desacoplada
    await showLoginModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroViewModel, IntroEntity>(
      builder: (context, state) {
        if (state.imageSize == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          body: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _onTap,
            child: Stack(
              children: [
                IntroBackground(
                  transformationController: _controller,
                  onTap: _onTap,
                ),
                Align(
                  alignment: const Alignment(0, -0.65),
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: const IntroLogo(),
                  ),
                ),
                if (state.showFlash && state.currentLightning.isNotEmpty)
                  FlashOverlay(opacity: _flashOpacity),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: PressHereButton(
                      blinkAnimation: _pressHereBlinkOpacity,
                      fastBlinkAnimation: _pressHereFastBlinkOpacity,
                      onTap: _onPressHereTap,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

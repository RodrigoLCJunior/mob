// lib/UI/intro_screen.dart
import 'package:flutter/material.dart';
import 'dart:math'; // Import para Random
import 'package:audioplayers/audioplayers.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/views/pages/game_start_screen.dart';
import 'package:midnight_never_end/views/widgets/login_modal.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // Único controlador
  late Animation<double> _logoOpacity; // Fade-in da logo
  late Animation<double> _flashOpacity; // Flash e relâmpago
  late Animation<double> _blinkOpacity; // Piscar do "Aperte aqui"
  final AudioPlayer _audioPlayer = AudioPlayer(); // Para o trovão
  final AudioPlayer _musicPlayer = AudioPlayer(); // Para a música em loop
  bool _showFlash = false;
  bool _isBlinkingFast = false;
  String userName = "Conta";
  bool _logoFadeInCompleted = false; // Controle para parar o piscar da logo
  String _currentLightning =
      "assets/images/lightning.png"; // Imagem inicial do relâmpago
  final List<String> _lightningImages = [
    "assets/images/lightning.png",
    "assets/images/lightning2.png",
    "assets/images/lightning3.png",
  ]; // Lista de imagens de relâmpago
  final Random _random = Random(); // Gerador de números aleatórios

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100), // Flash ultra rápido
      vsync: this,
    );

    // Animação da logo (fade-in inicial)
    _logoOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Animação do flash e relâmpago
    _flashOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Animação do "Aperte aqui"
    _blinkOpacity = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Inicia a animação da logo (fade-in)
    _controller.duration = const Duration(seconds: 2);
    _controller.forward().then((_) {
      setState(() {
        _logoFadeInCompleted = true; // Logo terminou o fade-in
      });
      _controller.duration = const Duration(seconds: 2); // Piscar normal
      _controller.repeat(reverse: true); // Inicia o piscar do "Aperte aqui"
    });

    // Inicia a música em loop
    _playBackgroundMusic();

    // Carrega o nome do usuário
    _loadUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    _musicPlayer.stop();
    _musicPlayer.dispose();
    super.dispose();
  }

  void _loadUser() {
    setState(() {
      userName = UserManager.currentUser?.nome ?? "Conta";
    });
  }

  void _updateUser() {
    setState(() {
      userName = UserManager.currentUser?.nome ?? "Conta";
    });
  }

  void _handleTap() {
    if (!_showFlash && !_isBlinkingFast) {
      // Escolhe uma imagem de relâmpago aleatória
      setState(() {
        _showFlash = true;
        _currentLightning =
            _lightningImages[_random.nextInt(_lightningImages.length)];
      });
      _playThunderSound();
      _controller.stop(); // Para o piscar
      _controller.duration = const Duration(
        milliseconds: 200,
      ); // Flash com relâmpago
      _controller.reset();
      _controller.forward().then((_) {
        setState(() {
          _showFlash = false;
        });
        _controller.duration = const Duration(
          seconds: 2,
        ); // Volta ao piscar normal
        _controller.repeat(reverse: true);
      });
    }
  }

  void _startGame() {
    if (!_isBlinkingFast) {
      setState(() {
        _isBlinkingFast = true;
      });
      _controller.stop();
      _controller.duration = const Duration(milliseconds: 200); // Piscar rápido
      _controller.repeat(reverse: true);

      // Após 2 segundos, abre o LoginModal diretamente
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          _controller.stop();
          setState(() {
            _isBlinkingFast = false;
          });
          showLoginModal(context).then((_) {
            _updateUser(); // Atualiza o nome após login
            if (UserManager.currentUser != null) {
              _musicPlayer.stop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GameStartScreen(),
                ),
              );
            }
          });
        }
      });
    }
  }

  Future<void> _playThunderSound() async {
    await _audioPlayer.stop();
    await _audioPlayer.setSource(AssetSource('audios/thunder.wav'));
    await _audioPlayer.resume();
  }

  Future<void> _playBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
      await _musicPlayer.setSource(AssetSource('audios/sons_of_liberty.mp3'));
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(1.0);
      await _musicPlayer.resume();
      print("Música iniciada: sons_of_liberty.mp3");
    } catch (e) {
      print("Erro ao tocar música: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _handleTap,
        child: Stack(
          children: [
            // Background
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/background.jpg",
                  ), // Seu background
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Logo estática após fade-in
            Center(
              child: FadeTransition(
                opacity:
                    _logoFadeInCompleted
                        ? const AlwaysStoppedAnimation(1.0) // Logo fixa
                        : _logoOpacity, // Fade-in inicial
                child: Image.asset(
                  "assets/images/mgs2_logo.png",
                  width: 300,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Relâmpago aleatório
            if (_showFlash)
              FadeTransition(
                opacity: _flashOpacity,
                child: Center(
                  child: Image.asset(
                    _currentLightning, // Imagem aleatória
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            // Flash (sobre o relâmpago)
            if (_showFlash)
              FadeTransition(
                opacity: _flashOpacity,
                child: Container(
                  color: Colors.white.withOpacity(
                    0.5,
                  ), // Opacidade para ver o relâmpago
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            // Texto "Aperte aqui" com piscar
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: FadeTransition(
                  opacity: _blinkOpacity,
                  child: GestureDetector(
                    onTap: _startGame,
                    child: const Text(
                      "- Aperte aqui -",
                      style: TextStyle(
                        fontFamily: "Kirsty",
                        fontSize: 30,
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
      ),
    );
  }
}

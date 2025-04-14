import 'package:flutter/material.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/views/pages/intro_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _logout(BuildContext context, VoidCallback updateState) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    UserManager.currentUser = null;
    updateState();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Logout realizado com sucesso"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  } catch (e) {
    print('Erro ao fazer logout: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Erro ao fazer logout. Tente novamente."),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
      ),
    );
  }
}

void _showSignOutConfirmation(
    BuildContext context, VoidCallback updateState, AudioPlayer Function() getPlayer) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return SignOutConfirmationDialog(
        onConfirm: () async {
          final player = getPlayer();
          try {
            await player.stop(); // Stop any ongoing sound
            await player.play(AssetSource('audios/tec.wav')); // Play sound on confirm
          } catch (e) {
            print('Erro ao tocar som de logout: $e');
          }
          await _logout(dialogContext, updateState);
          if (dialogContext.mounted) {
            Navigator.pop(dialogContext); // Close dialog
            Navigator.pop(dialogContext); // Close modal
            Navigator.pushAndRemoveUntil(
              dialogContext,
              MaterialPageRoute(builder: (context) => const IntroScreen()),
              (route) => false,
            );
          }
        },
        onCancel: () async {
          final player = getPlayer();
          try {
            await player.stop(); // Stop any ongoing sound
            await player.play(AssetSource('audios/tec.wav')); // Play sound on cancel
          } catch (e) {
            print('Erro ao tocar som de cancelar: $e');
          }
          Navigator.pop(dialogContext);
        },
        getPlayer: getPlayer,
      );
    },
  );
}

class SignOutConfirmationDialog extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final AudioPlayer Function() getPlayer;

  const SignOutConfirmationDialog({
    super.key,
    required this.onConfirm,
    required this.onCancel,
    required this.getPlayer,
  });

  @override
  _SignOutConfirmationDialogState createState() =>
      _SignOutConfirmationDialogState();
}

class _SignOutConfirmationDialogState extends State<SignOutConfirmationDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.grey[900]!.withOpacity(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.cyanAccent.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.cyanAccent.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (bounds) {
                    return LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.5),
                        Colors.cyanAccent.withOpacity(_glowAnimation.value),
                        Colors.white.withOpacity(0.5),
                      ],
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcATop,
                  child: const Text(
                    "CONFIRMAÇÃO",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
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
                );
              },
            ),
            const SizedBox(height: 16),
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Text(
                  "Tem certeza que deseja sair?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.8),
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
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: widget.onCancel,
                  child: AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.cyanAccent.withOpacity(0.3),
                              blurRadius: 10 * _glowAnimation.value,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          "CANCELAR",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
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
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: widget.onConfirm,
                  child: AnimatedBuilder(
                    animation: _glowAnimation,
                    builder: (context, child) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.redAccent.withOpacity(0.5),
                              blurRadius: 10 * _glowAnimation.value,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Text(
                          "SAIR",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void showAccountOptions(
  BuildContext context,
  String userName,
  VoidCallback updateState,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext modalContext) {
      return _AccountOptionsModal(userName: userName, updateState: updateState);
    },
  );
}

class _AccountOptionsModal extends StatefulWidget {
  final String userName;
  final VoidCallback updateState;

  const _AccountOptionsModal({
    required this.userName,
    required this.updateState,
  });

  @override
  __AccountOptionsModalState createState() => __AccountOptionsModalState();
}

class __AccountOptionsModalState extends State<_AccountOptionsModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;
  bool _isLogoutHovered = false;
  final List<AudioPlayer> _audioPlayers = [];
  int _currentPlayerIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize audio players
    for (int i = 0; i < 2; i++) {
      _audioPlayers.add(AudioPlayer());
    }
    _preloadSounds();

    // Initialize animations
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _glowAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.repeat(reverse: true);
    _controller.forward();
  }

  // Preload sounds
  Future<void> _preloadSounds() async {
    try {
      for (var player in _audioPlayers) {
        await player.setSource(AssetSource('audios/tec.wav'));
        await player.setVolume(0.5);
      }
      print("Sons pré-carregados com sucesso no modal");
    } catch (e) {
      print("Erro ao pré-carregar sons: $e");
    }
  }

  // Get next available audio player
  AudioPlayer _getNextPlayer() {
    final player = _audioPlayers[_currentPlayerIndex];
    _currentPlayerIndex = (_currentPlayerIndex + 1) % _audioPlayers.length;
    return player;
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var player in _audioPlayers) {
      player.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.25,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.grey[900]!.withOpacity(0.9),
              ],
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.5),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.cyanAccent.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.5),
                            Colors.cyanAccent.withOpacity(_glowAnimation.value),
                            Colors.white.withOpacity(0.5),
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcATop,
                      child: Text(
                        "OPÇÕES DA CONTA - ${widget.userName.toUpperCase()}",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTapDown: (_) {
                  setState(() {
                    _isLogoutHovered = true;
                  });
                },
                onTapUp: (_) async {
                  setState(() {
                    _isLogoutHovered = false;
                  });
                  print("Sair clicado no celular");
                  try {
                    final player = _getNextPlayer();
                    await player.stop(); // Stop any ongoing sound
                    await player.play(AssetSource('audios/tec.wav')); // Play sound
                  } catch (e) {
                    print('Erro ao tocar som de sair: $e');
                  }
                  _showSignOutConfirmation(context, widget.updateState, _getNextPlayer);
                },
                onTapCancel: () {
                  setState(() {
                    _isLogoutHovered = false;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  transform:
                      Matrix4.identity()..scale(_isLogoutHovered ? 1.05 : 1.0),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      GlowingIcon(
                        icon: Icons.logout,
                        size: 24,
                        onPressed: () {},
                        tooltip: "Sair",
                        glowAnimation: _glowAnimation,
                      ),
                      const SizedBox(width: 16),
                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, child) {
                          return Text(
                            "SAIR",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
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
                    ],
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

// Custom widget for glowing icons
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
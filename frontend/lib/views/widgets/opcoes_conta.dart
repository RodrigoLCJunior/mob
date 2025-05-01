import 'package:flutter/material.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/views/pages/intro_screen.dart';
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleLogout() async {
    await _logout(context, widget.updateState);
    if (context.mounted) {
      Navigator.pop(context); // Fecha o modal de opções
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const IntroScreen()),
        (route) => false,
      );
    }
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
                    return Text(
                      "OPÇÕES DA CONTA - ${widget.userName.toUpperCase()}",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(_glowAnimation.value),
                        fontFamily: "Cinzel",
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.cyanAccent.withOpacity(0.5),
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _handleLogout,
                child: Row(
                  children: [
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Icon(
                          Icons.logout,
                          size: 24,
                          color: Colors.cyanAccent.withOpacity(
                            _glowAnimation.value,
                          ),
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.cyanAccent.withOpacity(0.5),
                              offset: const Offset(0, 0),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    AnimatedBuilder(
                      animation: _glowAnimation,
                      builder: (context, child) {
                        return Text(
                          "SAIR",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(
                              _glowAnimation.value,
                            ),
                            fontFamily: "Cinzel",
                            shadows: [
                              Shadow(
                                blurRadius: 10.0,
                                color: Colors.cyanAccent.withOpacity(0.5),
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
            ],
          ),
        ),
      ),
    );
  }
}

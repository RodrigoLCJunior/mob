import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/core/library/overlay_notification.dart';
import 'package:midnight_never_end/ui/intro/pages/intro_screen.dart';
import 'package:midnight_never_end/ui/opcoes_conta/view_models/opcoes_conta_bloc.dart';

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
      return BlocProvider(
        create:
            (context) => AccountOptionsBloc()..add(InitializeEvent(userName)),
        child: _AccountOptionsModal(updateState: updateState),
      );
    },
  );
}

class _AccountOptionsModal extends StatefulWidget {
  final VoidCallback updateState;

  const _AccountOptionsModal({required this.updateState});

  @override
  __AccountOptionsModalState createState() => __AccountOptionsModalState();
}

class __AccountOptionsModalState extends State<_AccountOptionsModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

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

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

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
    return BlocListener<AccountOptionsBloc, AccountOptionsState>(
      listener: (context, state) {
        // Mostrar mensagem de sucesso ou erro
        if (state.errorMessage != null) {
          OverlayNotification.show(
            context: context,
            message: state.errorMessage!,
            backgroundColor:
                state.isLogoutSuccess ? Colors.green : Colors.redAccent,
            duration: const Duration(seconds: 1),
          );
        }

        // Navegar para IntroScreen após logout bem-sucedido
        if (state.isLogoutSuccess) {
          Future.delayed(const Duration(seconds: 1), () {
            widget.updateState();
            Navigator.pop(context); // Fecha o modal
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const IntroScreen(),
                transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                ) {
                  const begin = 0.0;
                  const end = 1.0;
                  const curve = Curves.easeInOut;
                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return FadeTransition(
                    opacity: animation.drive(tween),
                    child: child,
                  );
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
              (Route<dynamic> route) => false,
            );
          });
        }
      },
      child: BlocBuilder<AccountOptionsBloc, AccountOptionsState>(
        builder: (context, state) {
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
                            "OPÇÕES DA CONTA - ${state.userName.toUpperCase()}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
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
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed:
                          state.isLoading
                              ? null
                              : () => context.read<AccountOptionsBloc>().add(
                                LogoutEvent(),
                              ),
                      child: Row(
                        children: [
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Icon(
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
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          AnimatedBuilder(
                            animation: _glowAnimation,
                            builder: (context, child) {
                              return Text(
                                state.isLoading ? "SAINDO..." : "SAIR",
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
        },
      ),
    );
  }
}

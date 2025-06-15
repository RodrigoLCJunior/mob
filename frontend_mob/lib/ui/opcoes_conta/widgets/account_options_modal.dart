import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/domain/entities/core/request_state_entity.dart';
import 'package:midnight_never_end/ui/intro/pages/intro_page.dart';
import 'package:midnight_never_end/ui/opcoes_conta/view_model/opcoes_conta_view_model.dart';

class AccountOptionsModal extends StatefulWidget {
  final String userName;

  const AccountOptionsModal({super.key, required this.userName});

  @override
  AccountOptionsModalState createState() => AccountOptionsModalState();
}

class AccountOptionsModalState extends State<AccountOptionsModal>
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountOptionsViewModel, IRequestState<String>>(
      listener: (context, state) {
        if (state is RequestCompletedState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Logout realizado com sucesso"),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context); // Fecha o modal ou página
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const IntroScreen()),
            (route) => false,
          );
        } else if (state is RequestErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error.toString()),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final viewModel = context.read<AccountOptionsViewModel>();
        final isLoading = state is RequestProcessingState;

        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
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
                mainAxisSize: MainAxisSize.min,
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
                        isLoading ? null : () => viewModel.logout(context),
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
                              isLoading ? "SAINDO..." : "SAIR",
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
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/core/library/overlay_notification.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';
import 'package:midnight_never_end/ui/auth/cadastro/view_models/cadastro_block.dart';
import 'package:midnight_never_end/ui/game_start/pages/game_start_screen.dart';

Future<bool> showCadastroModal(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: false,
    builder:
        (context) => BlocProvider(
          create: (context) => CadastroBloc(userService: UserService()),
          child: const CadastroModal(),
        ),
  ).then((value) => value ?? false);
}

class CadastroModal extends StatelessWidget {
  const CadastroModal({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<CadastroBloc, CadastroState>(
      listener: (context, state) {
        // Mostrar erro geral
        if (state.generalError != null) {
          OverlayNotification.show(
            context: context,
            message: state.generalError!,
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 3),
          );
        }

        // Mostrar sucesso e navegar para GameStartScreen
        if (state.isCadastroSuccess) {
          OverlayNotification.show(
            context: context,
            message: "Cadastro e login realizados com sucesso",
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context, true); // Fecha o CadastroModal
            Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder:
                    (context, animation, secondaryAnimation) =>
                        const GameStartScreen(),
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
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, size: 30),
                onPressed:
                    context.read<CadastroBloc>().state.isLoading
                        ? null
                        : () => Navigator.pop(context, false),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<CadastroBloc, CadastroState>(
                  builder: (context, state) {
                    final double screenWidth =
                        MediaQuery.of(context).size.width;
                    final double inputWidth = screenWidth - 40;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                "assets/images/rewalker.png",
                                width: 300,
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: inputWidth,
                          child: TextField(
                            onChanged:
                                (value) => context.read<CadastroBloc>().add(
                                  CadastroNomeChanged(value),
                                ),
                            enabled: !state.isLoading,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              hintText: "Digite seu nome",
                              filled: true,
                              fillColor: Colors.white,
                              errorText: state.nomeError,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: inputWidth,
                          child: TextField(
                            onChanged:
                                (value) => context.read<CadastroBloc>().add(
                                  CadastroEmailChanged(value),
                                ),
                            keyboardType: TextInputType.emailAddress,
                            enabled: !state.isLoading,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.email,
                                color: Colors.grey,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              hintText: "Digite seu email",
                              filled: true,
                              fillColor: Colors.white,
                              errorText: state.emailError,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: inputWidth,
                          child: TextField(
                            onChanged:
                                (value) => context.read<CadastroBloc>().add(
                                  CadastroSenhaChanged(value),
                                ),
                            obscureText: true,
                            enabled: !state.isLoading,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.grey,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              hintText: "Digite sua senha",
                              filled: true,
                              fillColor: Colors.white,
                              errorText: state.senhaError,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: inputWidth,
                          child: TextField(
                            onChanged:
                                (value) => context.read<CadastroBloc>().add(
                                  CadastroConfirmaSenhaChanged(value),
                                ),
                            obscureText: true,
                            enabled: !state.isLoading,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                              border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              hintText: "Confirme sua senha",
                              filled: true,
                              fillColor: Colors.white,
                              errorText: state.confirmaSenhaError,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF3B82F6),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: Size(inputWidth, 60),
                              elevation: 5,
                            ),
                            onPressed:
                                state.isLoading
                                    ? null
                                    : () => context.read<CadastroBloc>().add(
                                      CadastroSubmitted(),
                                    ),
                            child:
                                state.isLoading
                                    ? const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          "Cadastrando...",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                    : const Text(
                                      "Cadastrar",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/core/library/overlay_notification.dart';
import 'package:midnight_never_end/data/repositories/user/user_repository.dart';
import 'package:midnight_never_end/ui/auth/cadastro/pages/cadastro_modal.dart';
import 'package:midnight_never_end/ui/auth/login/view_models/login_bloc.dart';
import 'package:midnight_never_end/ui/game_start/pages/game_start_screen.dart';

Future<bool> showLoginModal(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: false,
    builder:
        (context) => BlocProvider(
          create: (context) => LoginBloc(userService: UserService()),
          child: LoginModal(),
        ),
  ).then((value) => value ?? false);
}

class LoginModal extends StatelessWidget {
  LoginModal({super.key});

  Future<void> _navigateToCadastro(BuildContext context) async {
    final bool isCadastroSuccess = await showCadastroModal(context);
    if (isCadastroSuccess) {
      Navigator.pop(context, true); // Fecha o LoginModal com sucesso
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
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

        // Mostrar sucesso, fechar o modal e navegar para GameStartScreen
        if (state.isLoginSuccess) {
          OverlayNotification.show(
            context: context,
            message: "Login realizado com sucesso",
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          );
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pop(context, true); // Fecha o modal
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
                    context.read<LoginBloc>().state.isLoading
                        ? null
                        : () => Navigator.pop(context, false),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: BlocBuilder<LoginBloc, LoginState>(
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
                                (value) => context.read<LoginBloc>().add(
                                  LoginEmailChanged(value),
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
                                (value) => context.read<LoginBloc>().add(
                                  LoginPasswordChanged(value),
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
                              errorText: state.passwordError,
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
                                    : () => context.read<LoginBloc>().add(
                                      LoginSubmitted(),
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
                                          "Logando...",
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
                                    : const Text(
                                      "Login",
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[400],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "Ou",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 1,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF1E3A8A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              minimumSize: Size(inputWidth, 60),
                              elevation: 5,
                            ),
                            onPressed:
                                state.isLoading
                                    ? null
                                    : () => _navigateToCadastro(context),
                            child: const Text(
                              "Cadastrar",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.black,
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

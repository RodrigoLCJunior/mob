import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:midnight_never_end/ui/cadastro/widgets/global_message_error_widget.dart';
import 'package:midnight_never_end/ui/game_start/pages/game_start_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/data/datasources/user/usuario_datasource.dart';
import 'package:midnight_never_end/ui/login/view_model/login_view_model.dart';
import 'package:midnight_never_end/domain/entities/login/login_entity.dart';
import 'package:midnight_never_end/ui/login/widgets/back_button_widget.dart';
import 'package:midnight_never_end/ui/login/widgets/divider_widget.dart';
import 'package:midnight_never_end/ui/login/widgets/email_input_widget.dart';
import 'package:midnight_never_end/ui/login/widgets/login_button_widget.dart';
import 'package:midnight_never_end/ui/login/widgets/logo_widget.dart';
import 'package:midnight_never_end/ui/login/widgets/password_input_widget.dart';
import 'package:midnight_never_end/ui/login/widgets/register_button_widget.dart';

Future<void> showLoginModal(BuildContext context) async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final client = Client();
  final usuarioDataSource = UsuarioDataSource(
    client: client,
    sharedPreferences: sharedPreferences,
  );

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: false,
    builder:
        (context) => BlocProvider(
          create: (_) => LoginViewModel(usuarioDataSource: usuarioDataSource),
          child: const LoginScreen(),
        ),
  );
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth = screenWidth - 40;

    return BlocListener<LoginViewModel, LoginEntity>(
      listener: (context, state) {
        if (state.success == true) {
          Navigator.of(context).pop(); // Fecha o modal
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const GameStartScreen()),
          );
        }
        // Opcional: mantenha o SnackBar como fallback ou remova se o GlobalErrorMessageWidget for suficiente
        /* if (state.errorMessage?.isNotEmpty == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
        } */
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
            BlocBuilder<LoginViewModel, LoginEntity>(
              builder: (context, state) {
                return state.errorMessage?.isNotEmpty == true
                    ? GlobalErrorMessageWidget(
                      errorMessage: state.errorMessage!,
                    )
                    : const SizedBox.shrink(); // Não exibe nada se não houver erro
              },
            ),
            const BackButtonWidget(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const LogoWidget(),
                    const SizedBox(height: 40),
                    EmailInputWidget(width: inputWidth),
                    const SizedBox(height: 20),
                    PasswordInputWidget(width: inputWidth),
                    const SizedBox(height: 40),
                    LoginButtonWidget(width: inputWidth),
                    const SizedBox(height: 20),
                    const DividerWidget(),
                    const SizedBox(height: 20),
                    RegisterButtonWidget(width: inputWidth),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

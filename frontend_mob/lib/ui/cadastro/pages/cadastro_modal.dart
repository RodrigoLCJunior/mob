import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/data/repositories/user/usuario_repository_factory.dart';
import 'package:midnight_never_end/domain/entities/cadastro/cadastro_entity.dart';
import 'package:midnight_never_end/ui/cadastro/view_models/cadastro_view_model.dart';
import 'package:midnight_never_end/ui/cadastro/widgets/back_button_widget.dart';
import 'package:midnight_never_end/ui/cadastro/widgets/cadastro_button_widget.dart';
import 'package:midnight_never_end/ui/cadastro/widgets/cadastro_form_widget.dart';
import 'package:midnight_never_end/ui/cadastro/widgets/global_message_error_widget.dart';
import 'package:midnight_never_end/ui/cadastro/widgets/logo_widget.dart';

Future<void> showCadastroModal(BuildContext context) async {
  final userRepository = await UserRepositoryFactory.create();

  return await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    enableDrag: false,
    builder:
        (modalContext) => BlocProvider(
          create: (_) => CadastroViewModel(userRepository: userRepository),
          child: CadastroModal(parentContext: context),
        ),
  );
}

class CadastroModal extends StatelessWidget {
  final BuildContext parentContext;

  const CadastroModal({Key? key, required this.parentContext})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double inputWidth = screenWidth - 40;

    return BlocBuilder<CadastroViewModel, CadastroEntity>(
      builder: (context, state) {
        final viewModel = context.read<CadastroViewModel>();
        return Container(
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
              const BackButtonWidget(),
              const SizedBox(height: 20),
              GlobalErrorMessageWidget(errorMessage: state.errorMessage),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const LogoWidget(),
                      const SizedBox(height: 40),
                      CadastroFormWidget(
                        inputWidth: inputWidth,
                        nome: state.nome,
                        email: state.email,
                        senha: state.senha,
                        confirmaSenha: state.confirmaSenha,
                        nomeError: state.nomeError,
                        emailError: state.emailError,
                        senhaError: state.senhaError,
                        confirmaSenhaError: state.confirmaSenhaError,
                        isLoading: state.isLoading,
                        onNomeChanged: viewModel.updateNome,
                        onEmailChanged: viewModel.updateEmail,
                        onSenhaChanged: viewModel.updateSenha,
                        onConfirmaSenhaChanged: viewModel.updateConfirmaSenha,
                      ),
                      const SizedBox(height: 40),
                      CadastroButtonWidget(width: inputWidth),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/ui/login/view_model/login_view_model.dart';
import 'package:midnight_never_end/domain/entities/login/login_entity.dart';

class PasswordInputWidget extends StatelessWidget {
  final double width;

  const PasswordInputWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    try {
      final viewModel = context.watch<LoginViewModel>();
      return SizedBox(
        width: width,
        child: TextFormField(
          enabled:
              !viewModel.state.isLoading, // Desativa durante o carregamento
          obscureText: true,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.lock, color: Colors.grey),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            hintText: "Digite sua senha",
            filled: true,
            fillColor: Colors.white,
            errorText: viewModel.state.passwordError,
          ),
          onChanged: (value) {
            try {
              viewModel.updatePassword(value);
            } catch (e) {
              print(
                'Erro ao atualizar senha no PasswordInputWidget às ${DateTime.now()}: $e',
              );
            }
          },
        ),
      );
    } catch (e) {
      return const SizedBox(
        child: Text(
          'Erro ao carregar campo de senha',
          style: TextStyle(color: Colors.red, fontSize: 14),
        ),
      );
    }
  }
}

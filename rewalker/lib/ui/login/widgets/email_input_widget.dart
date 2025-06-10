import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/ui/login/view_model/login_view_model.dart';
import 'package:midnight_never_end/domain/entities/login/login_entity.dart';

class EmailInputWidget extends StatelessWidget {
  final double width;

  const EmailInputWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    try {
      final viewModel = context.watch<LoginViewModel>();
      return SizedBox(
        width: width,
        child: TextFormField(
          enabled:
              !viewModel.state.isLoading, // Desativa durante o carregamento
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.email, color: Colors.grey),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            hintText: "Digite seu email",
            filled: true,
            fillColor: Colors.white,
            errorText: viewModel.state.emailError,
          ),
          onChanged: (value) {
            try {
              viewModel.updateEmail(value);
            } catch (e) {
              print(
                'Erro ao atualizar email no EmailInputWidget às ${DateTime.now()}: $e',
              );
            }
          },
        ),
      );
    } catch (e) {
      return const SizedBox(
        child: Text(
          'Erro ao carregar campo de email',
          style: TextStyle(color: Colors.red, fontSize: 14),
        ),
      );
    }
  }
}

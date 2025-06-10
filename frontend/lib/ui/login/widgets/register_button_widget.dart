import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/ui/cadastro/pages/cadastro_modal.dart';
import 'package:midnight_never_end/ui/login/view_model/login_view_model.dart';
import 'package:midnight_never_end/domain/entities/login/login_entity.dart';

class RegisterButtonWidget extends StatelessWidget {
  final double width;

  const RegisterButtonWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginViewModel, LoginEntity>(
      builder: (context, state) {
        return Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1E3A8A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: Size(width, 60),
              elevation: 5,
            ),
            onPressed:
                state.isLoading ? null : () => showCadastroModal(context),
            child: const Text(
              "Cadastrar",
              style: TextStyle(fontSize: 17, color: Colors.black),
            ),
          ),
        );
      },
    );
  }
}

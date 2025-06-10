import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/ui/cadastro/view_models/cadastro_view_model.dart';
import 'package:midnight_never_end/domain/entities/cadastro/cadastro_entity.dart';

class CadastroButtonWidget extends StatelessWidget {
  final double width;

  const CadastroButtonWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CadastroViewModel, CadastroEntity>(
      builder: (context, state) {
        return Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              minimumSize: Size(width, 60),
              elevation: 5,
            ),
            onPressed:
                state.isLoading
                    ? null
                    : () {
                      context.read<CadastroViewModel>().cadastrar();
                    },
            child:
                state.isLoading
                    ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3,
                      ),
                    )
                    : const Text(
                      "Cadastrar",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
          ),
        );
      },
    );
  }
}

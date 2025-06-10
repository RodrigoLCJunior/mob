import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/ui/login/view_model/login_view_model.dart';
import 'package:midnight_never_end/domain/entities/login/login_entity.dart';

class LoginButtonWidget extends StatelessWidget {
  final double width;

  const LoginButtonWidget({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginViewModel, LoginEntity>(
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
                    : () => context.read<LoginViewModel>().login(),
            child:
                state.isLoading
                    ? const SizedBox(
                      height: 26,
                      width: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text(
                      "Login",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
          ),
        );
      },
    );
  }
}

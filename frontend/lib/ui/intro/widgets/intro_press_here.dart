import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/intro_view_model.dart';
import '../../../domain/entities/intro/intro_entity.dart';

class PressHereButton extends StatelessWidget {
  final Animation<double> blinkAnimation;
  final Animation<double> fastBlinkAnimation;
  final VoidCallback onTap;

  const PressHereButton({
    super.key,
    required this.blinkAnimation,
    required this.fastBlinkAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroViewModel, IntroEntity>(
      buildWhen: (prev, curr) => prev.isBlinkingFast != curr.isBlinkingFast,
      builder: (context, state) {
        final animation =
            state.isBlinkingFast ? fastBlinkAnimation : blinkAnimation;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: FadeTransition(
            opacity: animation,
            child: const Text(
              "- PRESS HERE -",
              style: TextStyle(
                fontFamily: "Kirsty",
                fontSize: 20,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 5.0,
                    color: Color.fromARGB(255, 40, 40, 40),
                    offset: Offset(1, 1),
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

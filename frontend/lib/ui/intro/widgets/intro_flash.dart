import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../view_model/intro_view_model.dart';
import '../../../domain/entities/intro/intro_entity.dart';

class FlashOverlay extends StatelessWidget {
  final Animation<double> opacity;
  const FlashOverlay({super.key, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroViewModel, IntroEntity>(
      buildWhen:
          (previous, current) =>
              previous.showFlash != current.showFlash ||
              previous.currentLightning != current.currentLightning,
      builder: (context, state) {
        if (!state.showFlash || state.currentLightning.isEmpty) {
          return const SizedBox.shrink();
        }
        return FadeTransition(
          opacity: opacity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(state.currentLightning, fit: BoxFit.cover),
              ),
              Positioned.fill(
                child: Container(color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),
        );
      },
    );
  }
}

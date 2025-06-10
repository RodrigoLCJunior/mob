import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/ui/intro/view_model/intro_view_model.dart';
import 'package:midnight_never_end/domain/entities/intro/intro_entity.dart';

class IntroBackground extends StatelessWidget {
  final TransformationController transformationController;
  final VoidCallback onTap;

  const IntroBackground({
    super.key,
    required this.transformationController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroViewModel, IntroEntity>(
      buildWhen:
          (previous, current) =>
              previous.backgroundImage != current.backgroundImage ||
              previous.imageSize != current.imageSize,
      builder: (context, state) {
        if (state.imageSize == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final screenSize = MediaQuery.of(context).size;
        final imageSize_ = state.imageSize!;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final matrix = transformationController.value;
          if (matrix[12] == 0 && matrix[13] == 0) {
            final offsetX = (screenSize.width - imageSize_.width) / 2;
            final offsetY = (screenSize.height - imageSize_.height) / 2;
            transformationController.value =
                Matrix4.identity()..translate(offsetX, offsetY);
          }
        });

        return GestureDetector(
          onTap: onTap,
          child: InteractiveViewer(
            transformationController: transformationController,
            constrained: false,
            minScale: 1.0,
            maxScale: 1.0,
            panEnabled: true,
            scaleEnabled: false,
            child: SizedBox(
              width: imageSize_.width,
              height: imageSize_.height,
              child: Image.asset(
                state.backgroundImage,
                fit: BoxFit.cover,
                width: imageSize_.width,
                height: imageSize_.height,
              ),
            ),
          ),
        );
      },
    );
  }
}

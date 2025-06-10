import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class InfoTextComponent extends TextComponent {
  double lifetime = 2.5; // Duração total na tela
  double elapsedTime = 0.0;
  double opacity = 0.0;

  InfoTextComponent(String text, Vector2 position)
      : super(
          text: text,
          position: position,
          anchor: Anchor.center,
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Color(0xFFFFFF00), // Amarelo vibrante
              fontSize: 16,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Color(0xFF000000),
                  offset: Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        );

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;

    final t = (elapsedTime / lifetime).clamp(0.0, 1.0);

    // Fade-in nos primeiros 0.3s, depois fade-out
    if (t < 0.3) {
      opacity = t / 0.3; // fade in
    } else {
      opacity = 1.0 - ((t - 0.3) / (1.0 - 0.3)).clamp(0.0, 1.0); // fade out
    }

    textRenderer = TextPaint(
      style: TextStyle(
        color: const Color(0xFFFFFF00).withOpacity(opacity),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(color: Color(0xFF000000), offset: Offset(1, 1), blurRadius: 2),
        ],
      ),
    );

    if (elapsedTime >= lifetime) {
      removeFromParent();
    }
  }
}

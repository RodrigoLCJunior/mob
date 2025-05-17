import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class HealText extends TextComponent {
  double lifetime = 0.8; // Duração total da animação (em segundos)
  double elapsedTime = 0.0;
  final double initialY;
  double opacity = 1.0;

  HealText(String text, Vector2 position)
    : initialY = position.y,
      super(
        text: text,
        position: position,
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFFF4500),
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

    // Calcular a fração do tempo decorrido (0 a 1)
    final t = (elapsedTime / lifetime).clamp(0.0, 1.0);

    // Mover o texto para cima (30 pixels ao longo da animação)
    position.y = initialY - 30 * t;

    // Reduzir a opacidade gradualmente
    opacity = 1.0 - t;
    textRenderer = TextPaint(
      style: TextStyle(
        color: Colors.green.withOpacity(opacity),
        fontSize: 16,
        fontWeight: FontWeight.bold,
        shadows: const [
          Shadow(color: Color(0xFF000000), offset: Offset(1, 1), blurRadius: 2),
        ],
      ),
    );

    // Remover o texto quando a animação terminar
    if (elapsedTime >= lifetime) {
      removeFromParent();
    }
  }
}

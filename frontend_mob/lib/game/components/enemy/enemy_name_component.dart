import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:midnight_never_end/domain/entities/inimigo/inimigo_entity.dart';

class EnemyNameComponent extends TextComponent {
  final Inimigo inimigo;

  EnemyNameComponent(this.inimigo)
    : super(
        text: inimigo.nome.toUpperCase(),
        position: Vector2.zero(),
        anchor: Anchor.center,
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color(0xFFFFFFFF),
            fontSize: 14,
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
}

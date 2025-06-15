/// Este arquivo define a classe abstrata `BaseAnimatedCard`, que contém a lógica
/// comum para animar uma carta durante um ataque no jogo de combate.
///
/// Principais responsabilidades:
///
/// - Move a carta de uma posição inicial até uma posição-alvo (`targetPosition`)
///   em um tempo definido (`duration`), simulando um ataque.
/// - Durante a animação, a carta:
///   - se desloca em linha reta (interpolação manual),
///   - rotaciona até 45° (pi/4 rad) para um efeito dinâmico,
///   - encolhe nos últimos 20% do tempo de animação para simular um "fade-out" visual.
/// - Quando a animação termina, executa um callback ou lógica específica de ataque.
///
/// Essa classe serve como base para `AnimatedCard` (jogador) e `EnemyAnimatedCard` (inimigo).
import 'dart:ui';
import 'package:flame/components.dart';
import 'dart:math' as math;

import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';

abstract class BaseAnimatedCard extends PositionComponent {
  final Vector2 targetPosition;
  double elapsedTime = 0.0;
  final double duration = 0.5;
  final Vector2 startPosition;
  final double startAngle;
  double scaleFactor = 1.0;
  final Cards card;
  final int cardIndex;
  VoidCallback? onAnimationComplete;

  BaseAnimatedCard({
    required this.card,
    required this.startPosition,
    required this.startAngle,
    required this.targetPosition,
    required this.cardIndex,
    this.onAnimationComplete,
  }) {
    position = startPosition.clone();
    angle = startAngle;
    priority = 100;
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;

    final t = (elapsedTime / duration).clamp(0.0, 1.0);

    final x = startPosition.x + (targetPosition.x - startPosition.x) * t;
    final y = startPosition.y + (targetPosition.y - startPosition.y) * t;
    position = Vector2(x, y);

    // Rotação dinâmica até 45° (pi/4 radianos)
    angle = startAngle + t * math.pi / 4;

    if (t > 0.8) {
      scaleFactor = (1.0 - (t - 0.8) / 0.2).clamp(0.0, 1.0);
      scale = Vector2.all(scaleFactor);
    }

    if (elapsedTime >= duration) {
      onComplete();
      removeFromParent();
    }
  }

  void onComplete();
}

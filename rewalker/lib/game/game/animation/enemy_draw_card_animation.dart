/// Este arquivo define a classe `EnemyDrawCardAnimation`, que é responsável
/// por animar a compra de uma carta pelo inimigo em um jogo de combate baseado
/// em turnos usando o Flame.
///
/// A classe estende `EnemyCardComponent`, garantindo que apenas o verso da carta
/// seja exibido durante a animação, já que as cartas do inimigo não devem revelar
/// seus detalhes ao jogador.
///
/// Funcionalidades principais:
/// - Anima a carta de uma posição inicial (`startPosition`) até uma posição final
///   (`targetPosition`) com um movimento linear.
/// - Ajusta o ângulo da carta de `startAngle` para `endAngle` durante a animação.
/// - Aumenta a escala da carta de 0.3 para 1.0 para criar um efeito de "crescimento".
/// - Executa um callback (`onAnimationComplete`) ao finalizar e remove a carta da tela.

import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';
import 'package:midnight_never_end/game/components/enemy/enemy_card_component.dart';

class EnemyDrawCardAnimation extends EnemyCardComponent {
  final Vector2 targetPosition;
  final Vector2 startPosition;
  final double duration;
  double elapsedTime = 0.0;
  final double startAngle;
  final double endAngle;
  final VoidCallback? onAnimationComplete;

  EnemyDrawCardAnimation({
    required Cards card,
    required this.startPosition,
    required this.targetPosition,
    this.duration = 0.6,
    this.startAngle = -math.pi / 2,
    this.endAngle = 0.0,
    this.onAnimationComplete,
  }) : super(card, initialPosition: startPosition) {
    position = startPosition.clone();
    angle = startAngle;
    scale = Vector2.all(0.3);
    priority = 101; // Acima das cartas normais
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;
    final t = (elapsedTime / duration).clamp(0.0, 1.0);

    position = Vector2(
      startPosition.x + (targetPosition.x - startPosition.x) * t,
      startPosition.y + (targetPosition.y - startPosition.y) * t,
    );

    angle = startAngle + (endAngle - startAngle) * t;
    final scaleFactor = 0.3 + 0.7 * t;
    scale = Vector2.all(scaleFactor);

    if (t >= 1.0) {
      onAnimationComplete?.call();
      if (isMounted) {
        removeFromParent();
      }
    }
  }
}

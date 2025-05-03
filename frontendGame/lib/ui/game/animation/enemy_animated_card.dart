/// Este arquivo define a classe `EnemyAnimatedCard`, uma extensão de `EnemyCardComponent`
/// usada para animar visualmente uma carta jogada pelo inimigo contra o avatar do jogador
/// no jogo de combate.
///
/// Principais responsabilidades:
///
/// - A carta é movida suavemente de sua posição inicial até uma posição-alvo
///   (`targetPosition`) em um tempo definido (`duration`), simulando um ataque do inimigo.
///
/// - Durante a animação, a carta:
///   - se desloca em linha reta (interpolação manual),
///   - rotaciona até 45° (pi/4 rad) para um efeito dinâmico,
///   - encolhe nos últimos 20% do tempo de animação para simular um "fade-out" visual.
///
/// - Quando a animação termina:
///   - Executa o callback `onAnimationComplete` (se fornecido).
///   - Caso contrário, aplica a lógica de ataque via `viewModel.playEnemyCard`.
///   - Em seguida, a carta animada é removida da árvore de componentes do jogo.
///
/// Essa classe é usada para criar um efeito visual dinâmico e responsivo ao ataque do inimigo,
/// exibindo apenas o verso da carta para manter a ocultação das informações do inimigo.
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'dart:math' as math;

import 'package:midnight_never_end/ui/components/enemy/enemy_card_component.dart';

class EnemyAnimatedCard extends EnemyCardComponent {
  final Vector2 targetPosition;
  double elapsedTime = 0.0;
  final double duration = 0.5;
  final Vector2 startPosition;
  final double startAngle;
  double scaleFactor = 1.0;
  final Cards card;
  final int cardIndex;
  final CombatViewModel viewModel;
  VoidCallback? onAnimationComplete;

  EnemyAnimatedCard({
    required this.card,
    required this.startPosition,
    required this.startAngle,
    required this.targetPosition,
    required this.cardIndex,
    required this.viewModel,
    this.onAnimationComplete,
  }) : super(card, initialPosition: startPosition) {
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

    // Restaurar rotação dinâmica até 45° (pi/4 radianos)
    angle = startAngle + t * math.pi / 4;

    if (t > 0.8) {
      scaleFactor = (1.0 - (t - 0.8) / 0.2).clamp(0.0, 1.0);
      scale = Vector2.all(scaleFactor);
    }

    if (elapsedTime >= duration) {
      if (onAnimationComplete != null) {
        onAnimationComplete!();
      } else {
        viewModel.playEnemyCard(card, cardIndex);
      }
      removeFromParent();
    }
  }
}

/// Este arquivo gerencia o posicionamento e rotação das cartas do jogador
/// em um jogo de combate baseado em turnos usando o Flame.
///
/// Função principal:
///
/// - `posicionarCartasJogador`: Posiciona as cartas do jogador (`cartasJogador`)
///   em um arco abaixo do `avatarComponent`, calculando as posições e ângulos
///   com base no número de cartas e na geometria circular, além de ajustar
///   a animação de compra (`DrawCardAnimation`).

import 'package:flame/components.dart';
import 'dart:math' as math;
import 'package:midnight_never_end/ui/game/combat_game.dart';
import 'package:midnight_never_end/ui/game/animation/draw_card_animation.dart';

void posicionarCartasJogador(CombatGame game) {
  if (!game.isComponentsLoaded || game.avatarComponent == null) {
    print(
      'CombatGame - posicionarCartasJogador skipped: components not loaded (player_card_positioning.dart)',
    );
    return;
  }

  final totalCartas = game.cartasJogador.length;
  final double cartaWidth = 60.0;
  final double overlap = 40.0;
  final double totalWidth =
      cartaWidth + (totalCartas - 1) * (cartaWidth - overlap);
  final double startX = (game.size.x - totalWidth) / 2;

  final double centerY = game.avatarComponent!.position.y + 50;
  final double radius = 150.0; // Altura das cartas
  final double maxAngle = (math.pi / 15); // ~15 graus

  for (int i = 0; i < totalCartas; i++) {
    final carta = game.cartasJogador[i];
    final double x = startX + i * (cartaWidth - overlap);

    final double t =
        (i - (totalCartas - 1) / 2) /
        (totalCartas == 1 ? 1 : (totalCartas - 1));
    final double angle = totalCartas == 1 ? 0 : t * maxAngle;

    final double y = centerY - radius * math.cos(angle);
    final double adjustedX = x + radius * math.sin(angle);

    carta.position = Vector2(adjustedX, y - 30);
    carta.setOriginalPosition(carta.position);

    if (!game.children.contains(carta)) {
      DrawCardAnimation? animation;
      try {
        animation = game.children.whereType<DrawCardAnimation>().firstWhere(
          (anim) => anim.card == carta.card,
        );
      } catch (_) {
        animation = null;
      }
      if (animation != null) {
        animation.targetPosition.setFrom(carta.position);
      }
    }

    carta.angle = angle;
    carta.originalAngle = angle;
    carta.priority = i;

    print(
      'CombatGame - Carta do jogador ${carta.card.nome} positioned at position=${carta.position}, angle=${carta.angle} (player_card_positioning.dart)',
    );
  }
}

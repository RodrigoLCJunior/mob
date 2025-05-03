import 'package:flame/components.dart';
import 'dart:math' as math;
import 'package:midnight_never_end/ui/game/combat_game.dart';
import 'package:midnight_never_end/ui/game/draw_card_animation.dart';

void posicionarCartasJogador(CombatGame game) {
  if (!game.isComponentsLoaded || game.avatarComponent == null) {
    print('CombatGame - posicionarCartasJogador skipped: components not loaded (card_positioning.dart)');
    return;
  }

  final totalCartas = game.cartasJogador.length;
  final double cartaWidth = 60.0;
  final double overlap = 40.0;
  final double totalWidth = cartaWidth + (totalCartas - 1) * (cartaWidth - overlap);
  final double startX = (game.size.x - totalWidth) / 2;

  final double centerY = game.avatarComponent!.position.y + 50;
  final double radius = 150.0; // <- Altura das cartas ?
  final double maxAngle = (math.pi / 15); // <- ~15 graus

  for (int i = 0; i < totalCartas; i++) {
    final carta = game.cartasJogador[i];
    final double x = startX + i * (cartaWidth - overlap);

    final double t = (i - (totalCartas - 1) / 2) / (totalCartas == 1 ? 1 : (totalCartas - 1));
    final double angle = totalCartas == 1 ? 0 : t * maxAngle;

    final double y = centerY - radius * math.cos(angle);
    final double adjustedX = x + radius * math.sin(angle);

    carta.position = Vector2(adjustedX, y - 30);
    carta.setOriginalPosition(carta.position);

    if (!game.children.contains(carta)) {
      DrawCardAnimation? animation;
      try {
        animation = game.children
            .whereType<DrawCardAnimation>()
            .firstWhere((anim) => anim.card == carta.card);
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

    print('CombatGame - Carta do jogador ${carta.card.nome} positioned at position=${carta.position}, angle=${carta.angle} (card_positioning.dart)');
  }
}


void posicionarCartasInimigo(CombatGame game) {
  if (!game.isComponentsLoaded || game.inimigoComponent == null) {
    print('CombatGame - posicionarCartasInimigo skipped: components not loaded (card_positioning.dart)');
    return;
  }

  final totalCartas = game.cartasInimigo.length;
  final double cartaWidth = 60.0;
  final double overlap = 40.0;
  final double totalWidth = cartaWidth + (totalCartas - 1) * (cartaWidth - overlap);
  final double startX = (game.size.x - totalWidth) / 2;

  final double centerY = game.inimigoComponent!.position.y - 80;
  final double radius = 40.0; // Altura das cartas ?
  final double maxAngle = (math.pi / 12); // ~15 graus

  for (int i = 0; i < totalCartas; i++) {
    final carta = game.cartasInimigo[i];
    final double x = startX + i * (cartaWidth - overlap);

    final double t = (i - (totalCartas - 1) / 2) / (totalCartas == 1 ? 1 : (totalCartas - 1));
    final double angle = totalCartas == 1 ? 0 : t * maxAngle;

    final double y = centerY + radius * math.cos(angle);
    final double adjustedX = x + radius * math.sin(angle);

    carta.position = Vector2(adjustedX, y - 80);
    carta.setOriginalPosition(carta.position);

    carta.angle = angle;
    carta.originalAngle = angle;
    carta.priority = i;

    print('CombatGame - Carta do inimigo ${carta.card.nome} positioned at position=${carta.position}, angle=${carta.angle} (card_positioning.dart)');
  }
}


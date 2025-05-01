import 'package:flame/components.dart';
import 'dart:math' as math;
import 'package:midnight_never_end/ui/game/combat_game.dart';

void posicionarCartasJogador(CombatGame game) {
  if (!game.isComponentsLoaded || game.avatarComponent == null) {
    print(
      'CombatGame - posicionarCartasJogador skipped: components not loaded (card_positioning.dart)',
    );
    return;
  }

  final totalCartas = game.cartasJogador.length;
  final double cartaWidth = 60.0; // Largura de cada carta
  final double overlap = 30.0; // Sobreposição entre as cartas
  final double totalWidth =
      cartaWidth + (totalCartas - 1) * (cartaWidth - overlap);
  final double startX =
      (game.size.x - totalWidth) / 2; // Centralizar horizontalmente

  // Posição Y central das cartas, relativa ao avatar
  // Ajuste este valor para mover as cartas verticalmente (mais alto = valor menor)
  final double centerY = game.avatarComponent!.position.y + 50;

  // Raio da curvatura das cartas (aumente para uma curvatura mais pronunciada)
  final double radius = 100.0;

  // Ângulo máximo da curvatura (em radianos)
  // Aumente para uma curvatura mais ampla (máximo recomendado: pi/2)
  final double maxAngle = (math.pi / 4).toDouble();

  for (int i = 0; i < totalCartas; i++) {
    final carta = game.cartasJogador[i];
    final double x = startX + i * (cartaWidth - overlap);

    final double t = (i - (totalCartas - 1) / 2) / (totalCartas - 1);
    final double angle = totalCartas == 1 ? 0 : t * maxAngle;

    final double y = centerY - radius * math.cos(angle);
    final double adjustedX = x + radius * math.sin(angle);

    // Ajuste adicional da posição vertical (subir mais)
    // Aumente o valor negativo para subir mais (ex.: -30 para -40)
    carta.position = Vector2(adjustedX, y - 30);
    carta.setOriginalPosition(carta.position);

    carta.angle = angle;
    carta.originalAngle = angle;

    carta.priority = i;

    print(
      'CombatGame - Carta do jogador ${carta.card.nome} positioned at position=${carta.position}, angle=${carta.angle} (card_positioning.dart)',
    );
  }
}

void posicionarCartasInimigo(CombatGame game) {
  if (!game.isComponentsLoaded || game.inimigoComponent == null) {
    print(
      'CombatGame - posicionarCartasInimigo skipped: components not loaded (card_positioning.dart)',
    );
    return;
  }

  final totalCartas = game.cartasInimigo.length;
  final double cartaWidth = 60.0; // Largura de cada carta
  final double overlap = 30.0; // Sobreposição entre as cartas
  final double totalWidth =
      cartaWidth + (totalCartas - 1) * (cartaWidth - overlap);
  final double startX =
      (game.size.x - totalWidth) / 2; // Centralizar horizontalmente

  // Posição Y central das cartas, relativa ao inimigo
  // Ajuste este valor para mover as cartas verticalmente (mais alto = valor menor)
  final double centerY = game.inimigoComponent!.position.y - 80;

  // Raio da curvatura das cartas (aumente para uma curvatura mais pronunciada)
  final double radius = 100.0;

  // Ângulo máximo da curvatura (em radianos)
  // Aumente para uma curvatura mais ampla (máximo recomendado: pi/2)
  final double maxAngle = (math.pi / 4).toDouble();

  for (int i = 0; i < totalCartas; i++) {
    final carta = game.cartasInimigo[i];
    final double x = startX + i * (cartaWidth - overlap);

    final double t = (i - (totalCartas - 1) / 2) / (totalCartas - 1);
    final double angle = totalCartas == 1 ? 0 : t * maxAngle;

    final double y = centerY + radius * math.cos(angle);
    final double adjustedX = x + radius * math.sin(angle);

    // Ajuste adicional da posição vertical (subir mais)
    // Aumente o valor negativo para subir mais (ex.: -80 para -90)
    carta.position = Vector2(adjustedX, y - 80);
    carta.setOriginalPosition(carta.position);

    carta.angle = angle;
    carta.originalAngle = angle;

    carta.priority = i;

    print(
      'CombatGame - Carta do inimigo ${carta.card.nome} positioned at position=${carta.position}, angle=${carta.angle} (card_positioning.dart)',
    );
  }
}

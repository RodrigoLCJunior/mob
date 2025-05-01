/// Este arquivo define a classe `AnimatedCard`, uma extensão de `CardComponent`
/// usada para animar visualmente uma carta jogada contra o inimigo no jogo de combate.
///
/// Principais responsabilidades:
///
/// - A carta é movida suavemente de sua posição inicial até uma posição-alvo
///   (`targetPosition`) em um tempo definido (`duration`), simulando um ataque.
///
/// - Durante a animação, a carta:
///   - se desloca em linha reta (interpolação manual),
///   - rotaciona até 45° (pi/4 rad),
///   - encolhe nos últimos 20% do tempo de animação para simular um "fade-out" visual.
///
/// - Quando a animação termina:
///   - Se `onAnimationComplete` foi fornecido, o callback é executado.
///   - Caso contrário, executa `viewModel.playCard`, aplicando a lógica do uso da carta.
///   - Em seguida, a carta animada é removida da árvore de componentes do jogo.
///
/// Essa classe é usada para criar um efeito visual dinâmico e responsivo ao jogar cartas
/// durante o turno do jogador, melhorando a imersão e clareza da ação para o usuário.

import 'dart:ui';
import 'package:flame/components.dart';
import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/ui/components/card_component.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'dart:math' as math;

class AnimatedCard extends CardComponent {
  final Vector2 targetPosition;
  double elapsedTime = 0.0;
  final double duration = 0.5; // Duração da animação em segundos
  final Vector2 startPosition;
  final double startAngle;
  double scaleFactor = 1.0; // Usado para simular fade-out com escala
  final Cards card;
  final int cardIndex;
  final CombatViewModel viewModel;
  VoidCallback?
  onAnimationComplete; // Callback personalizado ao fim da animação

  AnimatedCard({
    required this.card,
    required this.startPosition,
    required this.startAngle,
    required this.targetPosition,
    required this.cardIndex,
    required this.viewModel,
    this.onAnimationComplete,
  }) : super(card, isDraggable: false) {
    position = startPosition.clone();
    angle = startAngle;
    priority = 100; // Alta prioridade para ficar acima de outros componentes
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;

    // Calcular a fração do tempo decorrido (0 a 1)
    final t = (elapsedTime / duration).clamp(0.0, 1.0);

    // Mover a carta linearmente até a posição alvo (implementação manual de lerp)
    final x = startPosition.x + (targetPosition.x - startPosition.x) * t;
    final y = startPosition.y + (targetPosition.y - startPosition.y) * t;
    position = Vector2(x, y);

    // Adicionar uma leve rotação durante o movimento
    angle = startAngle + t * math.pi / 4; // Rotaciona 45 graus (pi/4 radianos)

    // Reduzir a escala nos últimos 20% da animação para simular fade-out
    if (t > 0.8) {
      scaleFactor = (1.0 - (t - 0.8) / 0.2).clamp(0.0, 1.0);
      scale = Vector2.all(
        scaleFactor,
      ); // Reduz a escala para simular desaparecimento
    }

    // Quando a animação terminar, aplicar o dano e remover a carta
    if (elapsedTime >= duration) {
      if (onAnimationComplete != null) {
        onAnimationComplete!(); // Usar callback personalizado, se fornecido
      } else {
        viewModel.playCard(card, cardIndex); // Comportamento padrão (jogador)
      }
      removeFromParent();
    }
  }
}

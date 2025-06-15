/// Este arquivo define a classe `AnimatedCard`, usada para animar visualmente
/// uma carta jogada pelo jogador contra o inimigo no jogo de combate.
///
/// Principais responsabilidades:
///
/// - Extende `BaseAnimatedCard` para herdar a lógica de animação comum.
/// - Adiciona um `CardComponent` como filho para renderizar a frente da carta.
/// - Quando a animação termina, executa `viewModel.playCard` ou o callback fornecido.
///
/// Essa classe é usada para criar um efeito visual dinâmico e responsivo ao jogar cartas
/// durante o turno do jogador, exibindo a frente da carta para o usuário.
import 'package:flame/components.dart';
import 'package:flutter/animation.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';
import 'package:midnight_never_end/game/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/game/components/avatar/card_component.dart';
import '../geral/base_animated_card.dart';

class AnimatedCard extends BaseAnimatedCard {
  final CombatViewModel viewModel;
  late CardComponent cardComponent;

  AnimatedCard({
    required Cards card,
    required Vector2 startPosition,
    required double startAngle,
    required Vector2 targetPosition,
    required int cardIndex,
    required this.viewModel,
    VoidCallback? onAnimationComplete,
  }) : super(
         card: card,
         startPosition: startPosition,
         startAngle: startAngle,
         targetPosition: targetPosition,
         cardIndex: cardIndex,
         onAnimationComplete: onAnimationComplete,
       ) {
    cardComponent = CardComponent(card, isDraggable: false);
    add(cardComponent);
  }

  @override
  void onComplete() {
    if (onAnimationComplete != null) {
      onAnimationComplete!();
    } else {
      viewModel.playCard(card, cardIndex);
    }
  }
}

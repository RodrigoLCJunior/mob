/*
 * Classe: EnemyAction
 * --------------------------------------------------------
 * Essa classe encapsula a lógica de ações do inimigo durante o combate no jogo.
 * É responsável por gerenciar o comportamento do inimigo quando é seu turno,
 * incluindo a seleção e animação de cartas jogadas contra o avatar do jogador.
 *
 * Funcionalidades principais:
 * 
 * - Ação do Inimigo:
 *   - Quando for o turno do inimigo, ele seleciona automaticamente uma carta da sua mão.
 *   - A carta é animada até o avatar do jogador usando `AnimatedCard`.
 *   - Após a animação, a carta afeta o jogo via `CombatViewModel.playEnemyCard`.
 *   - Caso não haja cartas para jogar, o turno do inimigo é finalizado.
 *
 * A classe depende de referências ao `CombatGame` e ao `CombatViewModel` para
 * interagir com os componentes visuais e o estado do jogo.
 */

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/ui/game/animated_card.dart';
import 'combat_game.dart';
import 'card_positioning.dart';

class EnemyAction {
  final CombatGame game;
  final CombatViewModel viewModel;
  final VoidCallback onEnemyTurnComplete;

  EnemyAction({
    required this.game,
    required this.viewModel,
    required this.onEnemyTurnComplete,
  });

  /// Faz o inimigo jogar uma carta automaticamente contra o avatar.
  void playEnemyCard() {
    if (game.cartasInimigo.isEmpty || game.avatarComponent == null) {
      // Se não há cartas ou o avatar não está carregado, passar o turno
      viewModel.endEnemyTurn();
      onEnemyTurnComplete();
      print('CombatGame - Enemy turn ended: No cards left to play');
      return;
    }

    // Selecionar a primeira carta da mão do inimigo
    final cardComponent = game.cartasInimigo.first;
    final cardIndex = 0;

    // Remover a carta da mão e do jogo
    game.cartasInimigo.removeAt(cardIndex);
    game.remove(cardComponent);

    // Criar uma cópia animada da carta
    final animatedCard = AnimatedCard(
      card: cardComponent.card,
      startPosition: cardComponent.position.clone(),
      startAngle: cardComponent.angle,
      targetPosition:
          game.avatarComponent!.position + Vector2(60, 25), // Centro do avatar
      cardIndex: cardIndex,
      viewModel: viewModel,
    );

    // Definir o comportamento após a animação
    animatedCard.onAnimationComplete = () {
      print(
        'CombatGame - Enemy card animation completed: ${cardComponent.card.nome}',
      );
      viewModel.playEnemyCard(cardComponent.card, cardIndex);
      onEnemyTurnComplete();
    };

    game.add(animatedCard);

    // Reposicionar as cartas do inimigo após remover uma
    posicionarCartasInimigo(game);
  }
}

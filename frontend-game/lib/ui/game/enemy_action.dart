/*
 * Classe: EnemyAction
 * --------------------------------------------------------
 * Essa classe encapsula a lógica de ações do inimigo durante o combate no jogo.
 * É responsável por gerenciar o comportamento do inimigo quando é seu turno,
 * incluindo a seleção inteligente de cartas e animação de ataque contra o avatar
 * do jogador.
 *
 * Funcionalidades principais:
 * 
 * - Ação do Inimigo:
 *   - Seleciona uma carta da mão do inimigo com base em um critério simples (maior dano).
 *   - Anima a carta até o centro do avatar do jogador usando `EnemyAnimatedCard`.
 *   - Após a animação, aplica o efeito da carta via `viewModel.playEnemyCard`.
 *   - Caso não haja cartas para jogar, o turno do inimigo é finalizado.
 *   - Reposiciona as cartas restantes após o ataque.
 *
 * A classe depende de referências ao `CombatGame` e ao `CombatViewModel` para
 * interagir com os componentes visuais e o estado do jogo.
 */

import 'dart:ui';
import 'package:flame/game.dart';
import 'package:midnight_never_end/bloc/combat/combat_view_model.dart';
import 'package:midnight_never_end/ui/components/enemy/enemy_card_component.dart';
import 'package:midnight_never_end/ui/game/animation/enemy_animated_card.dart';
import 'package:midnight_never_end/ui/game/combat_game.dart';
import 'package:midnight_never_end/ui/game/positioning/enemy_card_positioning.dart';

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
      // Verificar se há cartas ou se o avatar está carregado
      viewModel.endEnemyTurn();
      onEnemyTurnComplete();
      print('CombatGame - Enemy turn ended: No cards left to play');
      return;
    }

    // Selecionar a carta com maior dano (critério simples de IA)
    final cardComponent = _selectBestCard();
    if (cardComponent == null) {
      viewModel.endEnemyTurn();
      onEnemyTurnComplete();
      print('CombatGame - Enemy turn ended: No suitable card found');
      return;
    }

    final cardIndex = game.cartasInimigo.indexOf(cardComponent);

    // Remover a carta da mão e do jogo
    //game.cartasInimigo.removeAt(cardIndex);
    //game.remove(cardComponent);

    // Calcular o centro do avatar como alvo da animação
    final targetPosition =
        game.avatarComponent!.position +
        Vector2(
          game.avatarComponent!.size.x / 2,
          game.avatarComponent!.size.y / 2,
        );

    // Criar e adicionar a animação da carta
    final animatedCard = EnemyAnimatedCard(
      card: cardComponent.card,
      startPosition: cardComponent.position.clone(),
      startAngle: cardComponent.angle,
      targetPosition: targetPosition,
      cardIndex: cardIndex,
      viewModel: viewModel,
      onAnimationComplete: () {
        try {
          print(
            'CombatGame - Enemy card animation completed: ${cardComponent.card.nome}',
          );
          viewModel.playEnemyCard(cardComponent.card, cardIndex);
          onEnemyTurnComplete();
          posicionarCartasInimigo(game);
        } catch (e) {
          print('CombatGame - Error during animation completion: $e');
          onEnemyTurnComplete();
        }
      },
    );

    game.add(animatedCard);
  }

  /// Seleciona a melhor carta com base em um critério simples (maior dano).
  EnemyCardComponent? _selectBestCard() {
    try {
      final hpAtual = viewModel.state.combat?.enemyHp ?? 0;
      final hpMaximo = viewModel.state.combat?.enemy.hp ?? 1;

      final cartas = game.cartasInimigo;

      if (cartas.isEmpty) return null;

      // 1. Se HP baixo, prioriza cura
      if (hpAtual < (hpMaximo / 2)) {
        final cartasCura =
            cartas.where((c) => c.card.tipoEfeito.name == 'CURA').toList();
        if (cartasCura.isNotEmpty) {
          return cartasCura.reduce(
              (a, b) => a.card.valor > b.card.valor ? a : b);
        }
      }

      // 2. Senão, usa carta de dano
      final cartasDano =
          cartas.where((c) => c.card.tipoEfeito.name == 'DANO').toList();
      if (cartasDano.isNotEmpty) {
        return cartasDano.reduce(
            (a, b) => a.card.valor > b.card.valor ? a : b);
      }

      // 3. Se não tiver cura nem dano, joga qualquer carta
      return cartas.first;
    } catch (e) {
      print('CombatGame - Error selecting best card: $e');
      return game.cartasInimigo.firstOrNull;
    }
  }
}

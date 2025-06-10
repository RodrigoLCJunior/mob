/// Este arquivo gerencia o carregamento, atualização, posicionamento e interação
/// das cartas do jogador em um jogo de combate baseado em turnos usando o Flame.
///
/// Funções principais:
///
/// - `loadPlayerCards`: Carrega visualmente as cartas da mão do jogador na tela,
///   cria instâncias de `CardComponent` com base na mão (`viewModel.state.maoAvatar`),
///   define se são arrastáveis e adiciona ao jogo.
///
/// - `handleCardDrop`: Trata o evento de soltar uma carta. Se a carta for solta sobre
///   o inimigo (dentro de uma hitbox expandida), remove a carta do campo e adiciona
///   uma animação de ataque usando `AnimatedCard`. Caso contrário, retorna a carta à
///   posição original.
///
/// - `updatePlayerCards`: Atualiza as cartas do jogador após alguma mudança na mão.
///   Remove as cartas antigas, recarrega as novas da mão atual, reposiciona em arco
///   (via `posicionarCartasJogador`) e define se elas são arrastáveis com base no
///   estado atual do turno (`isPlayerTurn`).
///
/// Este código depende dos componentes visuais do Flame (`CardComponent`, `AnimatedCard`,
/// etc.) e integra lógica de jogo com elementos visuais para permitir interação fluida
/// durante o combate.

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';
import 'package:midnight_never_end/game/components/avatar/card_component.dart';
import 'package:midnight_never_end/game/components/enemy/enemy_container_component.dart';
import 'package:midnight_never_end/game/game/animation/animated_card.dart';
import 'package:midnight_never_end/game/game/animation/animated_heal_card.dart';
import 'package:midnight_never_end/game/game/animation/draw_card_animation.dart';
import 'package:midnight_never_end/game/game/combat_game.dart';
import 'package:midnight_never_end/game/game/positioning/player_card_positioning.dart';

Future<void> loadPlayerCards(CombatGame game) async {
  game.cartasJogador.clear();

  for (int i = 0; i < game.viewModel.state.maoAvatar.length; i++) {
    final cardModel = game.viewModel.state.maoAvatar[i];

    final carta = CardComponent(
      cardModel,
      isDraggable: game.viewModel.state.isPlayerTurn,
      onDragEndCallback: (CardComponent card) {
        handleCardDrop(game, card, game.enemyContainer);
      },
    );

    game.cartasJogador.add(carta);
    final targetPosition = Vector2.zero();

    final animation = DrawCardAnimation(
      card: cardModel,
      startPosition: Vector2(game.size.x / 2, game.size.y / 2),
      targetPosition: targetPosition,
      onAnimationComplete: () {
        game.add(carta);
      },
    );

    game.add(animation);
  }
}

void handleCardDrop(
  CombatGame game,
  CardComponent card,
  EnemyContainerComponent? enemyContainer,
) {
  if (!game.isComponentsLoaded ||
      enemyContainer == null ||
      !game.viewModel.state.isPlayerTurn) {
    card.position = card.originalPosition.clone();
    print(
      'CombatGame - Card drop rejected: componentsLoaded=${game.isComponentsLoaded}, '
      'enemyContainer=$enemyContainer, isPlayerTurn=${game.viewModel.state.isPlayerTurn}',
    );
    return;
  }

  final enemyHitbox = Rect.fromLTWH(
    enemyContainer.position.x - 50,
    enemyContainer.position.y - 50,
    enemyContainer.size.x + 100,
    enemyContainer.size.y + 100,
  );

  if (enemyHitbox.contains(card.position.toOffset())) {
    // Encontrar o índice em maoAvatar pelo ID da carta
    final cardIndex = game.viewModel.state.maoAvatar.indexWhere(
      (c) => c.id == card.card.id,
    );
    if (cardIndex != -1) {
      print(
        'CombatGame - Card ${card.card.id} dropped on enemy, maoAvatar index=$cardIndex',
      );
      // Verificar se a carta está em cartasJogador
      final gameCardIndex = game.cartasJogador.indexWhere(
        (c) => c.card.id == card.card.id,
      );
      if (gameCardIndex != -1) {
        game.remove(card);
        game.cartasJogador.removeAt(gameCardIndex);
      } else {
        print(
          'CombatGame - Warning: Card ${card.card.id} not found in cartasJogador',
        );
      }

      if (card.card.tipoEfeito == TipoEfeito.CURA) {
        final healAnimation = AnimatedHealCard(
          card: card.card,
          cardIndex: cardIndex,
          viewModel: game.viewModel,
          startPosition: card.position.clone(),
        );
        game.add(healAnimation);
      } else {
        final animatedCard = AnimatedCard(
          card: card.card,
          startPosition: card.position.clone(),
          startAngle: card.angle,
          targetPosition: enemyContainer.getCenterPosition(),
          cardIndex: cardIndex,
          viewModel: game.viewModel,
        );
        game.add(animatedCard);
      }
    } else {
      print(
        'CombatGame - Card ${card.card.id} not found in maoAvatar: '
        '${game.viewModel.state.maoAvatar.map((c) => c.id).toList()}',
      );
      card.position = card.originalPosition.clone();
    }
  } else {
    print('CombatGame - Card ${card.card.id} dropped outside enemy hitbox');
    card.position = card.originalPosition.clone();
  }
}

Future<void> updatePlayerCards(CombatGame game) async {
  final novasCartasData = game.viewModel.state.maoAvatar;
  final cartasAnteriores = game.cartasJogador.map((c) => c.card.id).toList();

  // Identificar cartas que permaneceram, foram removidas ou são novas
  final cartasParaManter =
      game.cartasJogador
          .where((c) => novasCartasData.any((n) => n.id == c.card.id))
          .toList();
  final cartasParaRemover =
      game.cartasJogador
          .where((c) => !novasCartasData.any((n) => n.id == c.card.id))
          .toList();
  final novasCartasIds =
      novasCartasData
          .where((n) => !cartasAnteriores.contains(n.id))
          .map((n) => n.id)
          .toList();

  // Remover cartas que não estão mais na mão
  for (var carta in cartasParaRemover) {
    if (carta.isMounted) {
      game.remove(carta);
    }
  }
  game.cartasJogador.removeWhere((c) => cartasParaRemover.contains(c));

  // Criar novas cartas apenas para IDs novos
  final novasCartas = <CardComponent>[];
  for (final card in novasCartasData) {
    if (novasCartasIds.contains(card.id)) {
      final carta = CardComponent(
        card,
        isDraggable: game.viewModel.state.isPlayerTurn,
        onDragEndCallback: (CardComponent cardComp) {
          handleCardDrop(game, cardComp, game.enemyContainer);
        },
      );
      novasCartas.add(carta);
    }
  }

  // Adicionar novas cartas a game.cartasJogador
  game.cartasJogador.addAll(novasCartas);

  // Reposicionar todas as cartas (mantidas e novas)
  posicionarCartasJogador(game);

  // Animar apenas as novas cartas
  for (final carta in novasCartas) {
    final startPos = Vector2(game.size.x / 2, game.size.y / 2);
    final targetPos = carta.position.clone();

    carta.position = startPos;

    final animation = DrawCardAnimation(
      card: carta.card,
      startPosition: startPos,
      targetPosition: targetPos,
      onAnimationComplete: () {
        game.add(carta);
        carta.isDraggable = game.viewModel.state.isPlayerTurn;
        print(
          'CombatGame - Card ${carta.card.id} added, isDraggable=${carta.isDraggable}, '
          'isPlayerTurn=${game.viewModel.state.isPlayerTurn}',
        );
      },
    );
    game.add(animation);
  }

  // Adicionar cartas mantidas diretamente ao jogo
  for (final carta in cartasParaManter) {
    if (!carta.isMounted) {
      game.add(carta);
    }
    carta.isDraggable = game.viewModel.state.isPlayerTurn;
    print(
      'CombatGame - Card ${carta.card.id} kept, isDraggable=${carta.isDraggable}',
    );
  }
}

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
import 'package:midnight_never_end/ui/components/card_component.dart';
import 'package:midnight_never_end/ui/components/enemy_component.dart';
import 'package:midnight_never_end/ui/game/animated_card.dart';
import 'package:midnight_never_end/ui/game/card_positioning.dart';
import 'package:midnight_never_end/ui/game/combat_game.dart';
import 'package:midnight_never_end/ui/game/draw_card_animation.dart';

Future<void> loadPlayerCards(CombatGame game) async {
  game.cartasJogador.clear();

  for (int i = 0; i < game.viewModel.state.maoAvatar.length; i++) {
    final cardModel = game.viewModel.state.maoAvatar[i];

    final carta = CardComponent(
      cardModel,
      isDraggable: game.viewModel.state.isPlayerTurn,
      onDragEndCallback: (CardComponent card) {
        handleCardDrop(game, card, game.inimigoComponent);
      },
    );

    game.cartasJogador.add(carta);
    final targetPosition = Vector2.zero(); // será setado depois via posicionamento

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
  InimigoComponent? inimigoComponent,
) {
  if (!game.isComponentsLoaded ||
      inimigoComponent == null ||
      !game.viewModel.state.isPlayerTurn) {
    card.position = card.originalPosition.clone();
    return;
  }

  // Definir uma hitbox maior ao redor do inimigo para facilitar o drop
  final enemyHitbox = Rect.fromLTWH(
    inimigoComponent.position.x - 50, // Expandir 50 pixels para a esquerda
    inimigoComponent.position.y - 50, // Expandir 50 pixels para cima
    inimigoComponent.size.x + 100, // Aumentar a largura em 100 pixels
    inimigoComponent.size.y + 100, // Aumentar a altura em 100 pixels
  );

  // Verificar se a carta foi solta dentro da hitbox do inimigo
  if (enemyHitbox.contains(card.position.toOffset())) {
    final cardIndex = game.cartasJogador.indexOf(card);
    if (cardIndex != -1) {
      // Remover a carta original imediatamente
      game.remove(card);
      game.cartasJogador.removeAt(cardIndex);

      // Criar uma cópia animada da carta
      final animatedCard = AnimatedCard(
        card: card.card,
        startPosition: card.position.clone(),
        startAngle: card.angle,
        targetPosition:
            inimigoComponent.position + Vector2(60, 25), // Centro do inimigo
        cardIndex: cardIndex,
        viewModel: game.viewModel,
      );
      game.add(animatedCard);
    }
  } else {
    // Retornar a carta à posição original se não foi solta no inimigo
    card.position = card.originalPosition.clone();
  }
}

Future<void> updatePlayerCards(CombatGame game) async {
  final novasCartasData = game.viewModel.state.maoAvatar;
  final cartasAnteriores = game.cartasJogador.map((c) => c.card).toList();

  for (var carta in game.cartasJogador) {
    game.remove(carta);
  }
  game.cartasJogador.clear();

  final novasCartas = <CardComponent>[];

  for (final card in novasCartasData) {
    final carta = CardComponent(
      card,
      isDraggable: game.viewModel.state.isPlayerTurn,
      onDragEndCallback: (CardComponent cardComp) {
        handleCardDrop(game, cardComp, game.inimigoComponent);
      },
    );
    novasCartas.add(carta);
  }

  game.cartasJogador.addAll(novasCartas);
  posicionarCartasJogador(game);

  final cartasNovas = novasCartas
      .where((c) => !cartasAnteriores.any((prev) => prev.id == c.card.id))
      .toList();

  for (final carta in cartasNovas) {
    final animation = DrawCardAnimation(
      card: carta.card,
      startPosition: Vector2(game.size.x / 2, game.size.y / 2),
      targetPosition: carta.position.clone(),
      onAnimationComplete: () {
        game.add(carta);
      },
    );
    game.add(animation);
  }

  for (final carta in novasCartas) {
    if (!cartasNovas.contains(carta)) {
      game.add(carta);
    }
  }

  for (var carta in game.cartasJogador) {
    carta.isDraggable = game.viewModel.state.isPlayerTurn;
  }
}



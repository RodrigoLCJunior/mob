/// Este arquivo gerencia o carregamento, atualização, posicionamento e animação
/// das cartas do inimigo em um jogo de combate baseado em turnos usando o Flame.
///
/// Funções principais:
///
/// - `loadEnemyCards`: Carrega visualmente as cartas da mão do inimigo na tela,
///   cria instâncias de `EnemyCardComponent` com base na mão (`viewModel.state.maoInimigo`),
///   e adiciona ao jogo.
///
/// - `updateEnemyCards`: Atualiza as cartas do inimigo após alguma mudança na mão.
///   Remove as cartas antigas, recarrega as novas da mão atual, reposiciona em arco
///   (via `posicionarCartasInimigo`) e adiciona ao jogo com animação de compra
///   para novas cartas usando `EnemyDrawCardAnimation`.
///
/// - `playEnemyCard`: Executa a lógica de ataque do inimigo, removendo uma carta da mão,
///   animando-a com `AnimatedCard` até o avatar do jogador, e aplicando a lógica do jogo
///   via `viewModel.playEnemyCard`.

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:midnight_never_end/game/components/enemy/enemy_card_component.dart';
import 'package:midnight_never_end/game/game/animation/animated_card.dart';
import 'package:midnight_never_end/game/game/animation/enemy_draw_card_animation.dart';
import 'package:midnight_never_end/game/game/combat_game.dart';
import 'package:midnight_never_end/game/game/positioning/enemy_card_positioning.dart';

Future<void> loadEnemyCards(CombatGame game) async {
  game.cartasInimigo.clear();

  for (int i = 0; i < game.viewModel.state.maoInimigo.length; i++) {
    final cardModel = game.viewModel.state.maoInimigo[i];
    final carta = EnemyCardComponent(
      cardModel,
      initialPosition: Vector2.zero(), // Posição será ajustada depois
    );
    game.cartasInimigo.add(carta);
    game.add(carta);
  }
}

Future<void> updateEnemyCards(CombatGame game) async {
  final novasCartasData = game.viewModel.state.maoInimigo;
  final cartasAnteriores = game.cartasInimigo.map((c) => c.card).toList();

  for (var carta in game.cartasInimigo) {
    if (carta.isMounted) {
      game.remove(carta);
    }
  }

  game.cartasInimigo.clear();

  final novasCartas = <EnemyCardComponent>[];

  for (final card in novasCartasData) {
    final carta = EnemyCardComponent(card, initialPosition: Vector2.zero());
    novasCartas.add(carta);
  }

  game.cartasInimigo.addAll(novasCartas);
  posicionarCartasInimigo(game);

  final cartasNovas =
      novasCartas
          .where((c) => !cartasAnteriores.any((prev) => prev.id == c.card.id))
          .toList();

  for (final carta in cartasNovas) {
    final animation = EnemyDrawCardAnimation(
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
}

void playEnemyCard(CombatGame game, VoidCallback onEnemyTurnComplete) {
  if (game.cartasInimigo.isEmpty || game.avatarComponent == null) {
    game.viewModel.endEnemyTurn();
    onEnemyTurnComplete();
    print('CombatGame - Enemy turn ended: No cards left to play');
    return;
  }

  final cardComponent = game.cartasInimigo.first;
  final cardIndex = 0;

  game.cartasInimigo.removeAt(cardIndex);
  game.remove(cardComponent);

  // Calcular a posição central do AvatarComponent para a animação
  final targetPosition =
      game.avatarComponent!.position +
      Vector2(
        game.avatarComponent!.size.x / 2,
        game.avatarComponent!.size.y / 2,
      );

  final animatedCard = AnimatedCard(
    card: cardComponent.card,
    startPosition: cardComponent.position.clone(),
    startAngle: cardComponent.angle,
    targetPosition: targetPosition,
    cardIndex: cardIndex,
    viewModel: game.viewModel,
  );

  animatedCard.onAnimationComplete = () {
    print(
      'CombatGame - Enemy card animation completed: ${cardComponent.card.nome}',
    );
    game.viewModel.playEnemyCard(cardComponent.card, cardIndex);
    onEnemyTurnComplete();
    posicionarCartasInimigo(game);
  };

  game.add(animatedCard);
}

/*
 * Função: onStateChanged
 * -------------------------------------------
 * Esta função atualiza o estado visual do jogo `CombatGame` sempre que há uma
 * mudança no estado do `CombatViewModel`, refletindo isso nos componentes visuais
 * e lógicos da interface do usuário.
 *
 * Funcionalidades principais:
 * - Verifica se os componentes do jogo foram carregados antes de executar atualizações.
 * - Atualiza o HP do inimigo (`inimigoComponent`) e do avatar (`avatarComponent`) com base nos dados de combate.
 *   - Se o avatar tomou dano, aplica a animação de dano em vez de apenas alterar o valor.
 * - Sincroniza as cartas do jogador (`cartasJogador`) com a mão do estado (`viewModel.state.maoAvatar`).
 * - Sincroniza as cartas do inimigo (`cartasInimigo`) através da função `_syncEnemyCards`, 
 *   que remove as cartas anteriores e recria novas instâncias na tela com base em `viewModel.state.maoInimigo`.
 * - Atualiza a propriedade `isDraggable` das cartas do jogador com base no turno.
 *
 * A função `_syncEnemyCards`:
 * - Remove visualmente todas as cartas do inimigo atualmente exibidas.
 * - Cria novas instâncias de `CardComponent` com base na mão do inimigo do estado do CombatBloc.
 * - Adiciona essas novas cartas ao jogo e chama a função de posicionamento visual.
 *
 * Esse sistema garante que a interface do combate esteja sempre sincronizada com o estado do jogo.
 */

import 'package:flame/components.dart';
import 'package:midnight_never_end/ui/components/card_component.dart';
import 'package:midnight_never_end/ui/game/card_management.dart';
import 'package:midnight_never_end/ui/game/card_positioning.dart';
import 'package:midnight_never_end/ui/game/combat_game.dart';
import 'package:midnight_never_end/ui/game/draw_card_animation.dart';

void onStateChanged(CombatGame game) {
  if (!game.isComponentsLoaded) return;

  // Atualizar o HP do inimigo e do avatar diretamente nos componentes
  if (game.inimigoComponent != null && game.viewModel.state.combat != null) {
    game.inimigoComponent!.updateInimigo(
      game.combatData.enemy,
      enemyHp: game.viewModel.state.combat!.enemyHp,
    );
  }

  if (game.avatarComponent != null && game.viewModel.state.combat != null) {
    final newHp = game.viewModel.state.combat!.avatarHp;
    if (newHp < game.avatarComponent!.currentHp) {
      final damage = game.avatarComponent!.currentHp - newHp;
      game.avatarComponent!.takeDamage(damage);
    } else {
      game.avatarComponent!.currentHp = newHp;
    }
  }

  // Sincronizar as cartas do jogador com o estado do CombatBloc
  updatePlayerCards(game);

  // Sincronizar as cartas do inimigo com o estado do CombatBloc
  _syncEnemyCards(game);

  // Atualizar a propriedade isDraggable das cartas do jogador com base no turno
  final isPlayerTurn = game.viewModel.state.isPlayerTurn;
  for (var carta in game.cartasJogador) {
    if (carta.isDraggable != isPlayerTurn) {
      carta.isDraggable = isPlayerTurn;
    }
  }
}

void _syncEnemyCards(CombatGame game) {
  final cartasAnteriores = game.cartasInimigo.map((c) => c.card).toList();
  final novasCartasData = game.viewModel.state.maoInimigo;

  for (var carta in game.cartasInimigo) {
    game.remove(carta);
  }
  game.cartasInimigo.clear();

  final novasCartas = <CardComponent>[];

  for (final card in novasCartasData) {
    final carta = CardComponent(
      card,
      isDraggable: false,
    );
    novasCartas.add(carta);
  }

  game.cartasInimigo.addAll(novasCartas);
  posicionarCartasInimigo(game);

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
}




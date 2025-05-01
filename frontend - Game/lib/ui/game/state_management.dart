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

import 'package:midnight_never_end/ui/components/card_component.dart';
import 'package:midnight_never_end/ui/game/card_management.dart';
import 'package:midnight_never_end/ui/game/card_positioning.dart';
import 'package:midnight_never_end/ui/game/combat_game.dart';

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
  // Remover todas as cartas atuais do inimigo
  for (var carta in game.cartasInimigo) {
    game.remove(carta);
  }
  game.cartasInimigo.clear();

  // Recarregar as cartas do inimigo com base na mão do estado do CombatBloc
  for (int i = 0; i < game.viewModel.state.maoInimigo.length; i++) {
    final carta = CardComponent(
      game.viewModel.state.maoInimigo[i],
      isDraggable: false,
    );
    game.cartasInimigo.add(carta);
    game.add(carta);
  }

  // Reposicionar as cartas do inimigo
  posicionarCartasInimigo(game);
}

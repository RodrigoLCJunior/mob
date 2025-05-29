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
 *   que delega a atualização para `updateEnemyCards` no `enemy_card_management.dart`.
 * - Atualiza a propriedade `isDraggable` das cartas do jogador com base no turno.
 *
 * A função `_syncEnemyCards`:
 * - Agora apenas chama `updateEnemyCards` para sincronizar as cartas do inimigo,
 *   garantindo consistência com a lógica de gerenciamento de cartas do inimigo.
 *
 * Esse sistema garante que a interface do combate esteja sempre sincronizada com o estado do jogo.
 */

import 'package:midnight_never_end/ui/game/combat_game.dart';
import 'package:midnight_never_end/ui/game/management/enemy_card_management.dart';
import 'package:midnight_never_end/ui/game/management/player_card_management.dart';

void onStateChanged(CombatGame game) {
  if (!game.isComponentsLoaded) return;

  // Atualizar o HP do inimigo e do avatar diretamente nos componentes
  if (game.enemyContainer != null && game.viewModel.state.combat != null) {
    game.enemyContainer!.updateInimigo(
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
  // Delegar a sincronização das cartas do inimigo para updateEnemyCards
  updateEnemyCards(game);
}

/// Este arquivo define os eventos usados pelo `CombatBloc` para controlar a lógica de combate
/// no jogo de cartas.
///
/// Os eventos representam ações que podem ser disparadas na interface do usuário ou pelo sistema:
///
/// - `InitializeCombat`: Evento disparado para iniciar o combate com dados iniciais como decks e HPs.
/// - `PassTurn`: Alterna o controle entre jogador e inimigo.
/// - `PlayCard`: Representa o jogador jogando uma carta contra o inimigo.
/// - `PlayEnemyCard`: Representa o inimigo jogando uma carta contra o jogador.
/// - `EndEnemyTurn`: Finaliza o turno do inimigo e inicia o do jogador.
///
/// Cada evento pode carregar dados relevantes (como a carta e seu índice no deck) e sobrescreve
/// o `toString()` para facilitar o debug e o log de ações durante o jogo.

import 'package:midnight_never_end/models/combat_initial_data.dart';
import 'package:midnight_never_end/models/card.dart';

abstract class CombatEvent {}

class InitializeCombat extends CombatEvent {
  final CombatInitialData initialData;

  InitializeCombat(this.initialData);

  @override
  String toString() =>
      'InitializeCombat(initialData: $initialData) (combat_eve.dart)';
}

class PassTurn extends CombatEvent {
  PassTurn();

  @override
  String toString() => 'PassTurn()';
}

class PlayCard extends CombatEvent {
  final Cards card;
  final int cardIndex;

  PlayCard(this.card, this.cardIndex);

  @override
  String toString() =>
      'PlayCard(card: ${card.nome}, cardIndex: $cardIndex) (combat_event.dart)';
}

class PlayEnemyCard extends CombatEvent {
  final Cards card;
  final int cardIndex;

  PlayEnemyCard(this.card, this.cardIndex);

  @override
  String toString() =>
      'PlayEnemyCard(card: ${card.nome}, cardIndex: $cardIndex) (combat_event.dart)';
}

class EndEnemyTurn extends CombatEvent {
  EndEnemyTurn();

  @override
  String toString() => 'EndEnemyTurn() (combat_event.dart)';
}

class ClearStatusMessage extends CombatEvent {
  @override
  String toString() => 'ClearStatusMessage() (combat_event.dart)';
}

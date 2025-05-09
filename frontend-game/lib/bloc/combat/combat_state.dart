/// Este arquivo define a classe `CombatState`, responsável por representar o estado completo
/// do sistema de combate em um jogo de cartas.
///
/// Através dessa classe, o BLoC pode manter e modificar o estado do combate, incluindo:
///
/// - O carregamento de dados (`isLoading`)
/// - Mensagens de erro (`error`)
/// - Informações de combate como HPs e status (`combat`)
/// - Cartas na mão e nos decks do jogador e do inimigo
/// - Controle de turno e contagem de turnos
/// - Indicação de fim de jogo com resultado (`gameResult`)
///
/// Também possui:
/// - Um construtor `initial()` para gerar o estado inicial do combate.
/// - Um método `copyWith()` para gerar cópias modificadas do estado.
/// - Um `toString()` customizado para facilitar o debug.
///
/// Esta classe é essencial para a lógica reativa do combate, permitindo que mudanças sejam
/// observadas pela interface e pela lógica de jogo com clareza e precisão.

import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/models/combat.dart';

// CombatState guarda todas as informações do jogo, como quem é o turno, as cartas, etc.
class CombatState {
  final bool isLoading; // Indica se o jogo está carregando
  final String? error; // Guarda mensagens de erro, se houver
  final Combat? combat; // Informações do combate (HP do jogador e inimigo)
  final List<Cards> maoAvatar; // Cartas na mão do jogador
  final List<Cards> maoInimigo; // Cartas na mão do inimigo
  final List<Cards> deckAvatar; // Deck do jogador
  final List<Cards> deckInimigo; // Deck do inimigo
  final bool isPlayerTurn; // Indica se é o turno do jogador
  final String?
  gameResult; // Indica o resultado do jogo ("victory" ou "defeat")
  final int playerTurnCount; // Conta quantos turnos o jogador já teve
  final int enemyTurnCount; // Conta quantos turnos o inimigo já teve

  CombatState({
    required this.isLoading,
    this.error,
    this.combat,
    required this.maoAvatar,
    required this.maoInimigo,
    required this.deckAvatar,
    required this.deckInimigo,
    required this.isPlayerTurn,
    this.gameResult,
    required this.playerTurnCount,
    required this.enemyTurnCount,
  });

  // Método para criar o estado inicial do jogo
  factory CombatState.initial() {
    return CombatState(
      isLoading: false,
      error: null,
      combat: null,
      maoAvatar: [],
      maoInimigo: [],
      deckAvatar: [],
      deckInimigo: [],
      isPlayerTurn: true, // O jogo começa com o turno do jogador
      gameResult: null,
      playerTurnCount: 0, // Começa com 0 turnos
      enemyTurnCount: 0, // Começa com 0 turnos
    );
  }

  // Método para criar uma cópia do estado com algumas mudanças
  CombatState copyWith({
    bool? isLoading,
    String? error,
    Combat? combat,
    List<Cards>? maoAvatar,
    List<Cards>? maoInimigo,
    List<Cards>? deckAvatar,
    List<Cards>? deckInimigo,
    bool? isPlayerTurn,
    String? gameResult,
    int? playerTurnCount,
    int? enemyTurnCount,
  }) {
    return CombatState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      combat: combat ?? this.combat,
      maoAvatar: maoAvatar ?? this.maoAvatar,
      maoInimigo: maoInimigo ?? this.maoInimigo,
      deckAvatar: deckAvatar ?? this.deckAvatar,
      deckInimigo: deckInimigo ?? this.deckInimigo,
      isPlayerTurn: isPlayerTurn ?? this.isPlayerTurn,
      gameResult: gameResult ?? this.gameResult,
      playerTurnCount: playerTurnCount ?? this.playerTurnCount,
      enemyTurnCount: enemyTurnCount ?? this.enemyTurnCount,
    );
  }

  // Método para mostrar o estado do jogo nos logs
  @override
  String toString() {
    return 'CombatState(isLoading: $isLoading, error: $error, combat: $combat, '
        'maoAvatar: ${maoAvatar.length} cartas, maoInimigo: ${maoInimigo.length} cartas, '
        'deckAvatar: ${deckAvatar.length} cartas, deckInimigo: ${deckInimigo.length} cartas, '
        'isPlayerTurn: $isPlayerTurn, gameResult: $gameResult, '
        'playerTurnCount: $playerTurnCount, enemyTurnCount: $enemyTurnCount) (combat_state.dart)';
  }
}

/// Este arquivo define a classe `CombatState`, responsável por representar o estado completo
/// do sistema de combate em um jogo de cartas.
///
/// Através dessa classe, o BLoC pode manter e modificar o estado do combate, incluindo:
/// - O carregamento de dados (`isLoading`)
/// - Mensagens de erro (`error`)
/// - Informações de combate como HPs e status (`combat`)
/// - Cartas na mão e nos decks do jogador e do inimigo
/// - Controle de turno e contagem de turnos
/// - Indicação de fim de jogo com resultado (`gameResult`)
/// - Gerenciamento de waves e dungeons (`isDungeon`, `dungeonId`, `currentWave`, `totalWaves`, `currentEnemy`)
///
/// Também possui:
/// - Um construtor `initial()` para gerar o estado inicial do combate.
/// - Um método `copyWith()` para gerar cópias modificadas do estado.
/// - Um `toString()` customizado para facilitar o debug.

import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/models/combat.dart';
import 'package:midnight_never_end/models/inimigo.dart'; // Adicionei a classe Inimigo, ajuste conforme necessário

class CombatState {
  final bool isLoading;
  final String? error;
  final Combat? combat;

  final List<Cards> maoAvatar;
  final List<Cards> maoInimigo;
  final List<Cards> deckAvatar;
  final List<Cards> deckInimigo;

  final bool isPlayerTurn;
  final String? gameResult;
  final int playerTurnCount;
  final int enemyTurnCount;

  final int escudoAvatar;
  final int escudoInimigo;

  final int venenoAvatarTurnos;
  final int venenoInimigoTurnos;
  final int venenoAvatarValor;
  final int venenoInimigoValor;

  final bool isDungeon;
  final int? dungeonId;
  final int currentWave;
  final int totalWaves;
  final Inimigo? currentEnemy; // Novo campo para o inimigo da wave atual

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
    this.escudoAvatar = 0,
    this.escudoInimigo = 0,
    this.venenoAvatarTurnos = 0,
    this.venenoInimigoTurnos = 0,
    this.venenoAvatarValor = 0,
    this.venenoInimigoValor = 0,
    this.isDungeon = false,
    this.dungeonId,
    this.currentWave = 1,
    this.totalWaves = 1,
    this.currentEnemy, // Novo campo opcional
  });

  factory CombatState.initial() {
    return CombatState(
      isLoading: false,
      error: null,
      combat: null,
      maoAvatar: [],
      maoInimigo: [],
      deckAvatar: [],
      deckInimigo: [],
      isPlayerTurn: true,
      gameResult: null,
      playerTurnCount: 0,
      enemyTurnCount: 0,
      isDungeon: false,
      dungeonId: null,
      currentWave: 1,
      totalWaves: 1,
      currentEnemy: null,
    );
  }

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
    int? escudoAvatar,
    int? escudoInimigo,
    int? venenoAvatarTurnos,
    int? venenoInimigoTurnos,
    int? venenoAvatarValor,
    int? venenoInimigoValor,
    bool? isDungeon,
    int? dungeonId,
    int? currentWave,
    int? totalWaves,
    Inimigo? currentEnemy, // Novo campo no copyWith
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
      escudoAvatar: escudoAvatar ?? this.escudoAvatar,
      escudoInimigo: escudoInimigo ?? this.escudoInimigo,
      venenoAvatarTurnos: venenoAvatarTurnos ?? this.venenoAvatarTurnos,
      venenoInimigoTurnos: venenoInimigoTurnos ?? this.venenoInimigoTurnos,
      venenoAvatarValor: venenoAvatarValor ?? this.venenoAvatarValor,
      venenoInimigoValor: venenoInimigoValor ?? this.venenoInimigoValor,
      isDungeon: isDungeon ?? this.isDungeon,
      dungeonId: dungeonId ?? this.dungeonId,
      currentWave: currentWave ?? this.currentWave,
      totalWaves: totalWaves ?? this.totalWaves,
      currentEnemy: currentEnemy ?? this.currentEnemy,
    );
  }

  @override
  String toString() {
    return 'CombatState(isLoading: $isLoading, error: $error, '
        'combat: $combat, maoAvatar: ${maoAvatar.length}, maoInimigo: ${maoInimigo.length}, '
        'deckAvatar: ${deckAvatar.length}, deckInimigo: ${deckInimigo.length}, '
        'isPlayerTurn: $isPlayerTurn, playerTurnCount: $playerTurnCount, '
        'enemyTurnCount: $enemyTurnCount, gameResult: $gameResult, '
        'escudoAvatar: $escudoAvatar, escudoInimigo: $escudoInimigo, '
        'venenoAvatarTurnos: $venenoAvatarTurnos, venenoInimigoTurnos: $venenoInimigoTurnos, '
        'venenoAvatarValor: $venenoAvatarValor, venenoInimigoValor: $venenoInimigoValor, '
        'isDungeon: $isDungeon, dungeonId: $dungeonId, currentWave: $currentWave, '
        'totalWaves: $totalWaves, currentEnemy: $currentEnemy)';
  }
}
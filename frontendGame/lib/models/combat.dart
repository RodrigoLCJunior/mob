import 'package:midnight_never_end/models/avatar.dart';
import 'package:midnight_never_end/models/inimigo.dart';
import 'package:midnight_never_end/models/combat_initial_data.dart';

class Combat {
  final Avatar avatar;
  final Inimigo enemy;
  final int avatarHp;
  final int enemyHp;
  final String currentTurn; // 'PLAYER' ou 'ENEMY'
  final bool isCombatActive;
  final bool playerWon;
  final bool playerLost;

  Combat({
    required this.avatar,
    required this.enemy,
    required this.avatarHp,
    required this.enemyHp,
    required this.currentTurn,
    required this.isCombatActive,
    required this.playerWon,
    required this.playerLost,
  });

  factory Combat.fromInitialData(CombatInitialData data) {
    return Combat(
      avatar: data.avatar,
      enemy: data.enemy,
      avatarHp: data.avatar.hp,
      enemyHp: data.enemy.hp,
      currentTurn: 'PLAYER', // Começa com o turno do jogador
      isCombatActive: true,
      playerWon: false,
      playerLost: false,
    );
  }

  Combat copyWith({
    Avatar? avatar,
    Inimigo? enemy,
    int? avatarHp,
    int? enemyHp,
    String? currentTurn,
    bool? isCombatActive,
    bool? playerWon,
    bool? playerLost,
  }) {
    return Combat(
      avatar: avatar ?? this.avatar,
      enemy: enemy ?? this.enemy,
      avatarHp: avatarHp ?? this.avatarHp,
      enemyHp: enemyHp ?? this.enemyHp,
      currentTurn: currentTurn ?? this.currentTurn,
      isCombatActive: isCombatActive ?? this.isCombatActive,
      playerWon: playerWon ?? this.playerWon,
      playerLost: playerLost ?? this.playerLost,
    );
  }
}

import 'package:midnight_never_end/models/avatar.dart';
import 'package:midnight_never_end/models/inimigo.dart';
import 'package:midnight_never_end/models/dungeon.dart';
import 'package:midnight_never_end/models/wave.dart';

class CombatInitialData {
  final Avatar avatar;
  final Inimigo enemy;
  final Dungeon dungeon;
  final Wave wave;

  CombatInitialData({
    required this.avatar,
    required this.enemy,
    required this.dungeon,
    required this.wave,
  });

  factory CombatInitialData.fromJson(Map<String, dynamic> json) {
    final combatData = json['combatData'] as Map<String, dynamic>? ?? {};

    return CombatInitialData(
      avatar: Avatar.fromJson(combatData['avatar'] ?? {}),
      enemy: Inimigo.fromJson(combatData['enemy'] ?? {}),
      dungeon: Dungeon.fromJson(json['dungeon'] ?? {}),
      wave: Wave.fromJson(json['wave'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'combatData': {
        'avatar': avatar.toJson(),
        'enemy': enemy.toJson(),
      },
      'dungeon': dungeon.toJson(),
      'wave': wave.toJson(),
    };
  }
}

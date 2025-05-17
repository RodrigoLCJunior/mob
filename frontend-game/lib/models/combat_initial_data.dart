import 'package:midnight_never_end/models/avatar.dart';
import 'package:midnight_never_end/models/inimigo.dart';

class CombatInitialData {
  final Avatar avatar;
  final Inimigo enemy;

  CombatInitialData({required this.avatar, required this.enemy});

  factory CombatInitialData.fromJson(Map<String, dynamic> json) {
    // Ajustar para lidar com a chave "combatData"
    final combatData = json['combatData'] as Map<String, dynamic>? ?? {};

    return CombatInitialData(
      avatar: Avatar.fromJson(combatData['avatar'] ?? {}),
      enemy: Inimigo.fromJson(combatData['enemy'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'combatData': {'avatar': avatar.toJson(), 'enemy': enemy.toJson()},
    };
  }
}

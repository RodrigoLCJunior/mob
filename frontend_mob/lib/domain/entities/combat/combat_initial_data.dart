import 'dart:convert';

import 'package:midnight_never_end/domain/entities/avatar/avatar_entity.dart';
import 'package:midnight_never_end/domain/entities/inimigo/inimigo_entity.dart';

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

  factory CombatInitialData.fromRemoteMap(Map<String, dynamic> map) {
    return CombatInitialData.fromJson(map);
  }

  factory CombatInitialData.fromStorageMap(Map<String, dynamic> map) {
    return CombatInitialData.fromJson(map);
  }

  Map<String, dynamic> toMap() {
    return {
      'combatData': jsonEncode({
        'avatar': avatar.toMap(),
        'enemy': enemy.toMap(),
      }),
    };
  }

  // Método para atualizar os dados do usuário sem modificar a instância original
  CombatInitialData copyWith({Avatar? avatar, Inimigo? enemy}) {
    return CombatInitialData(
      avatar: avatar ?? this.avatar,
      enemy: enemy ?? this.enemy,
    );
  }
}

import 'package:midnight_never_end/models/avatar.dart';
import 'package:midnight_never_end/models/inimigo.dart';
import 'package:midnight_never_end/models/wave.dart';

class CombatInitialData {
  final Avatar avatar;
  final Inimigo enemy;
  final Wave wave;

  CombatInitialData({
    required this.avatar,
    required this.enemy,
    required this.wave,
  });

  factory CombatInitialData.fromJson(Map<String, dynamic> json) {
    print('CombatInitialData.fromJson - JSON: $json');

    return CombatInitialData(
      avatar: Avatar.fromJson(json['avatar'] ?? {}),
      enemy: Inimigo.fromJson(json['enemy'] ?? {}),
      wave: Wave.fromJson(json['wave'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'combatData': {
        'avatar': avatar.toJson(),
        'enemy': enemy.toJson(),
      },
      'wave': wave.toJson(),
    };
  }
}

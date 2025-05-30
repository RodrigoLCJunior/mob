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
  final data = json['combatData'] ?? json; // usa o mais profundo, se existir
  print('CombatInitialData.fromJson - JSON: $data');

  return CombatInitialData(
    avatar: Avatar.fromJson(data['avatar'] ?? {}),
    enemy: Inimigo.fromJson(data['enemy'] ?? {}),
    wave: Wave.fromJson(data['wave'] ?? {}),
  );
}


  Map<String, dynamic> toJson() {
    return {
      'combatData': {
        'avatar': avatar.toJson(),
        'enemy': enemy.toJson(),
        'wave': wave.toJson(),
      },
    };
  }
}

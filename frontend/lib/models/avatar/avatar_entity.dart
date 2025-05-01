// lib/models/avatar_entity.dart
import '../progressao/progressao_entity.dart';

class Avatar {
  final String id;
  final int hp;
  final int danoBase;
  final Progressao? progressao;

  Avatar({
    required this.id,
    required this.hp,
    required this.danoBase,
    this.progressao,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
      id: json['id'] as String,
      hp: json['hp'] as int,
      danoBase: json['danoBase'] as int,
      progressao:
          json['progressao'] != null
              ? Progressao.fromJson(json['progressao'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hp': hp,
      'danoBase': danoBase,
      'progressao': progressao?.toJson(),
    };
  }

  Avatar copyWith({
    String? id,
    int? hp,
    int? danoBase,
    Progressao? progressao,
  }) {
    return Avatar(
      id: id ?? this.id,
      hp: hp ?? this.hp,
      danoBase: danoBase ?? this.danoBase,
      progressao: progressao ?? this.progressao,
    );
  }
}

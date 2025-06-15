import 'dart:convert';

import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';
import 'package:midnight_never_end/domain/entities/progressao/progressao_entity.dart';

final class Avatar {
  final String id;
  final int hp;
  final Progressao? progressao;
  final List<Cards> deck;

  const Avatar({
    required this.id,
    required this.hp,
    this.progressao,
    required this.deck,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    dynamic progressaoData = json['progressao'];
    Progressao? progressao;

    if (progressaoData != null) {
      if (progressaoData is Map<String, dynamic>) {
        progressao = Progressao.fromJson(progressaoData);
      } else if (progressaoData is String) {
        progressao = Progressao(
          id: progressaoData,
          totalMoedasTemporarias: 0,
          totalCliques: 0,
          totalInimigosDerrotados: 0,
          avatarId: progressaoData,
        );
      }
    }

    return Avatar(
      id: json['id'] as String? ?? '',
      hp: json['hp'] as int? ?? 0,
      progressao: progressao,
      deck:
          (json['deck'] as List?)
              ?.map((e) => Cards.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hp': hp,
      'progressao': progressao?.toJson(),
      'deck': deck.map((e) => e.toJson()).toList(),
    };
  }

  factory Avatar.fromRemoteMap(Map<String, dynamic> map) {
    return _fromMap(
      map: map,
      progressaoMap: map[kKeyProgressao] as Map<String, dynamic>?,
      progressaoString: map[kKeyProgressao] as String?,
    );
  }

  factory Avatar.fromStorageMap(Map<String, dynamic> map) {
    return _fromMap(
      map: map,
      progressaoMap:
          map[kKeyProgressao] != null
              ? jsonDecode(map[kKeyProgressao]) as Map<String, dynamic>
              : null,
      progressaoString: map[kKeyProgressao] as String?,
    );
  }

  static Avatar _fromMap({
    required Map<String, dynamic> map,
    Map<String, dynamic>? progressaoMap,
    String? progressaoString,
  }) {
    Progressao? progressao;
    if (progressaoMap != null) {
      progressao = Progressao.fromMap(progressaoMap);
    } else if (progressaoString != null) {
      progressao = Progressao(
        id: progressaoString,
        totalMoedasTemporarias: 0,
        totalCliques: 0,
        totalInimigosDerrotados: 0,
        avatarId: progressaoString,
      );
    }

    return Avatar(
      id: map[kKeyId] as String? ?? '',
      hp: map[kKeyHp] as int? ?? 0,
      progressao: progressao,
      deck:
          (map[kKeyDeck] as List?)
              ?.map((e) => Cards.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      kKeyId: id,
      kKeyHp: hp,
      kKeyProgressao:
          progressao != null ? jsonEncode(progressao?.toMap()) : null,
      kKeyDeck: jsonEncode(deck.map((e) => e.toMap()).toList()),
    };
  }

  Avatar copyWith({
    String? id,
    int? hp,
    Progressao? progressao,
    List<Cards>? deck,
  }) {
    return Avatar(
      id: id ?? this.id,
      hp: hp ?? this.hp,
      progressao: progressao ?? this.progressao,
      deck: deck ?? this.deck,
    );
  }

  static const String kKeyId = 'id';
  static const String kKeyHp = 'hp';
  static const String kKeyProgressao = 'progressao';
  static const String kKeyDeck = 'deck';
}

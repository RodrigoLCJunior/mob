import 'dart:convert';

import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';

class Inimigo {
  final int id;
  final String nome;
  final int hp;
  final int recompensa;
  final String? imageInimigo;
  final List<Cards> deck;

  Inimigo({
    required this.id,
    required this.nome,
    required this.hp,
    required this.recompensa,
    required this.imageInimigo,
    required this.deck,
  });

  factory Inimigo.fromJson(Map<String, dynamic> json) {
    return Inimigo(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String,
      hp: json['hp'] as int,
      recompensa: json['recompensa'] as int,
      imageInimigo: json['imageInimigo'] as String?,
      deck:
          (json['deck'] as List<dynamic>)
              .map(
                (cardJson) => Cards.fromJson(cardJson as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  get enemyImage => null;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'hp': hp,
      'recompensa': recompensa,
      'imageInimigo': imageInimigo,
      'deck': deck.map((card) => card.toJson()).toList(),
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'hp': hp,
      'recompensa': recompensa,
      'imageInimigo': imageInimigo,
      'deck': jsonEncode(deck.map((card) => card.toMap()).toList()),
    };
  }

  static Inimigo fromMap(Map<String, dynamic> map) {
    return Inimigo(
      id: (map['id'] as num).toInt(),
      nome: map['nome'] as String,
      hp: map['hp'] as int,
      recompensa: map['recompensa'] as int,
      imageInimigo: map['imageInimigo'] as String?,
      deck:
          (jsonDecode(map['deck'] as String) as List)
              .map((cardMap) => Cards.fromMap(cardMap as Map<String, dynamic>))
              .toList(),
    );
  }

  // Método para atualizar os dados do usuário sem modificar a instância original
  Inimigo copyWith({
    int? id,
    String? nome,
    int? hp,
    int? recompensa,
    String? imageInimigo,
    List<Cards>? deck,
  }) {
    return Inimigo(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      hp: hp ?? this.hp,
      recompensa: recompensa ?? this.recompensa,
      imageInimigo: imageInimigo ?? this.imageInimigo,
      deck: deck ?? this.deck,
    );
  }
}

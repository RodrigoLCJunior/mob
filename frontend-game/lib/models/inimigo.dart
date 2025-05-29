import 'package:midnight_never_end/models/card.dart';

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
      id: (json['id'] as int).toInt(),
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
}

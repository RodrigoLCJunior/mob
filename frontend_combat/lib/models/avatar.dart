import 'package:midnight_never_end/models/card.dart';
import 'package:midnight_never_end/models/progressao.dart';

class Avatar {
  final String id;
  final int hp;
  final Progressao? progressao;
  final List<Cards> deck;

  Avatar({
    required this.id,
    required this.hp,
    this.progressao,
    required this.deck,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    print('Avatar.fromJson - JSON: $json');
    dynamic progressaoData = json['progressao'];
    Progressao? progressao;

    if (progressaoData != null) {
      if (progressaoData is Map<String, dynamic>) {
        progressao = Progressao.fromJson(progressaoData);
      } else if (progressaoData is String) {
        print(
          'Avatar.fromJson - Progressao is a String, creating default Progressao',
        );
        progressao = Progressao(
          id: progressaoData,
          totalMoedasTemporarias: 0,
          totalCliques: 0,
          totalInimigosDerrotados: 0,
          avatarId: progressaoData,
        );
      } else {
        print(
          'Avatar.fromJson - Unexpected type for progressao: ${progressaoData.runtimeType}',
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

  // Método para atualizar os dados do usuário sem modificar a instância original
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
}

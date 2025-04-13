// lib/models/dungeon_entity.dart
class Dungeon {
  final int id;
  final String nome;
  final int numeroWaves;
  final bool concluida;
  final bool bloqueada;

  Dungeon({
    required this.id,
    required this.nome,
    required this.numeroWaves,
    required this.concluida,
    required this.bloqueada,
  });

  factory Dungeon.fromJson(Map<String, dynamic> json) {
    return Dungeon(
      id: json['id'] as int,
      nome: json['nome'] as String,
      numeroWaves: json['numeroWaves'] as int,
      concluida: json['concluida'] as bool,
      bloqueada: json['bloqueada'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'numeroWaves': numeroWaves,
      'concluida': concluida,
      'bloqueada': bloqueada,
    };
  }

  Dungeon copyWith({
    int? id,
    String? nome,
    int? numeroWaves,
    bool? concluida,
    bool? bloqueada,
  }) {
    return Dungeon(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      numeroWaves: numeroWaves ?? this.numeroWaves,
      concluida: concluida ?? this.concluida,
      bloqueada: bloqueada ?? this.bloqueada,
    );
  }
}

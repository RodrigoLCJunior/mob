class Dungeon {
  final int id;
  final String nome;
  final int qtdWaves;

  Dungeon({
    required this.id,
    required this.nome,
    required this.qtdWaves,
  });

  factory Dungeon.fromJson(Map<String, dynamic> json) {
    return Dungeon(
      id: json['id'],
      nome: json['nome'],
      qtdWaves: json['qtdWaves'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'qtdWaves': qtdWaves,
    };
  }
}

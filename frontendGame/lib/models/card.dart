class Cards {
  final int id;
  final String nome;
  final String? descricao;
  final int damage;

  Cards({
    required this.id,
    required this.nome,
    this.descricao,
    required this.damage,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String?,
      damage: json['damage'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nome': nome, 'descricao': descricao, 'damage': damage};
  }
}

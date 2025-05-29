class Cards {
  final int id;
  final String nome;
  final String? descricao;
  final int damage;
  final String? imageCard;

  Cards({
    required this.id,
    required this.nome,
    this.descricao,
    required this.damage,
    required this.imageCard,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String?,
      damage: json['damage'] as int? ?? 0,
      imageCard: json['imageCard'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'damage': damage,
      'imageCard': imageCard,
    };
  }

  // Método para atualizar os dados do usuário sem modificar a instância original
  Cards copyWith({
    int? id,
    String? nome,
    String? descricao,
    int? damage,
    String? imageCard,
  }) {
    return Cards(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      damage: damage ?? this.damage,
      imageCard: imageCard ?? this.imageCard,
    );
  }
}

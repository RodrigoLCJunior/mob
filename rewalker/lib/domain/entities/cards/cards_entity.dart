enum TipoEfeito {
  DANO,
  CURA,
  ESCUDO,
  VENENO,
  BUFF,
  DEBUFF;

  static TipoEfeito fromString(String value) {
    return TipoEfeito.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TipoEfeito.DANO,
    ); // Adicionado orElse para evitar erro caso não encontre
  }

  String toJson() => name;
}

final class Cards {
  final int id;
  final String nome;
  final String? descricao;
  final int valor; // Alterado de 'damage' para 'valor' para ser mais genérico
  final String? imageCard;
  final TipoEfeito tipoEfeito; // Novo campo
  final int qtdTurnos; // Novo campo

  const Cards({
    required this.id,
    required this.nome,
    this.descricao,
    required this.valor,
    required this.imageCard,
    required this.tipoEfeito, // Novo campo
    required this.qtdTurnos, // Novo campo
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      id: json['id'] as int? ?? 0,
      nome: json['nome'] as String? ?? '',
      descricao: json['descricao'] as String?,
      valor: json['valor'] as int? ?? 0,
      imageCard: json['imageCard'] as String?,
      tipoEfeito: TipoEfeito.fromString(
        json['tipoEfeito'] as String? ?? 'DANO',
      ), // Garante valor padrão
      qtdTurnos: json['qtdTurnos'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'imageCard': imageCard,
      'tipoEfeito': tipoEfeito.toJson(),
      'qtdTurnos': qtdTurnos,
    };
  }

  factory Cards.fromMap(Map<String, dynamic> map) {
    return Cards(
      id: map['id'] as int? ?? 0,
      nome: map['nome'] as String? ?? '',
      descricao: map['descricao'] as String?,
      valor: map['valor'] as int? ?? 0,
      imageCard: map['imageCard'] as String?,
      tipoEfeito: TipoEfeito.fromString(
        map['tipoEfeito'] as String? ?? 'DANO',
      ), // Garante valor padrão
      qtdTurnos: map['qtdTurnos'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'valor': valor,
      'imageCard': imageCard,
      'tipoEfeito': tipoEfeito.toJson(),
      'qtdTurnos': qtdTurnos,
    };
  }

  Cards copyWith({
    int? id,
    String? nome,
    String? descricao,
    int? valor, // Alterado de 'damage' para 'valor'
    String? imageCard,
    TipoEfeito? tipoEfeito, // Novo campo
    int? qtdTurnos, // Novo campo
  }) {
    return Cards(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      descricao: descricao ?? this.descricao,
      valor: valor ?? this.valor,
      imageCard: imageCard ?? this.imageCard,
      tipoEfeito: tipoEfeito ?? this.tipoEfeito,
      qtdTurnos: qtdTurnos ?? this.qtdTurnos,
    );
  }
}

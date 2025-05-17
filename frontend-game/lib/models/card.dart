//Angelo: Alteracao para adicao de enum de tipo de efeito, e mudanca de nome de variavel
//damage -> valor

enum TipoEfeito {
  DANO,
  CURA,
  ESCUDO,
  VENENO,
  BUFF,
  DEBUFF;

  static TipoEfeito fromString(String value) {
    return TipoEfeito.values.firstWhere((e) => e.name == value);
  }

  String toJson() => name;
}

class Cards {
  final int id;
  final String nome;
  final String? descricao;
  final int valor;
  final String? imageCard;
  final TipoEfeito tipoEfeito;
  final int qtdTurnos;

  Cards({
    required this.id,
    required this.nome,
    this.descricao,
    required this.valor,
    required this.imageCard,
    required this.tipoEfeito,
    required this.qtdTurnos,
  });

  factory Cards.fromJson(Map<String, dynamic> json) {
    return Cards(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String?,
      valor: json['valor'] as int? ?? 0,
      imageCard: json['imageCard'] as String?,
      tipoEfeito: TipoEfeito.fromString(json['tipoEfeito'] as String),
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
}

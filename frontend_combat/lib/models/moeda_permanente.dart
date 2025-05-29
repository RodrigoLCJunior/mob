class MoedaPermanente {
  final String id;
  final int quantidade;

  MoedaPermanente({required this.id, required this.quantidade});

  factory MoedaPermanente.fromJson(Map<String, dynamic> json) {
    return MoedaPermanente(
      id: json['id'] as String,
      quantidade: json['quantidade'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'quantidade': quantidade};
  }

  // Método para atualizar os dados do usuário sem modificar a instância original
  MoedaPermanente copyWith({String? id, int? quantidade}) {
    return MoedaPermanente(
      id: id ?? this.id,
      quantidade: quantidade ?? this.quantidade,
    );
  }
}

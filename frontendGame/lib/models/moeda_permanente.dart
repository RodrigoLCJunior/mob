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
}

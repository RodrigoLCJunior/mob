final class MoedaPermanente {
  final String id;
  final int quantidade;

  const MoedaPermanente({required this.id, required this.quantidade});

  factory MoedaPermanente.fromJson(Map<String, dynamic> json) {
    return MoedaPermanente(
      id: json['id'] as String? ?? '',
      quantidade: json['quantidade'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'quantidade': quantidade};
  }

  factory MoedaPermanente.fromMap(Map<String, dynamic> map) {
    return MoedaPermanente(
      id: map['id'] as String? ?? '',
      quantidade: map['quantidade'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'quantidade': quantidade};
  }

  MoedaPermanente copyWith({String? id, int? quantidade}) {
    return MoedaPermanente(
      id: id ?? this.id,
      quantidade: quantidade ?? this.quantidade,
    );
  }
}

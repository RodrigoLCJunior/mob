/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Entidade da moedaPermanente
 ** Obs...:
 */

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

  MoedaPermanente copyWith({String? id, int? quantidade}) {
    return MoedaPermanente(
      id: id ?? this.id,
      quantidade: quantidade ?? this.quantidade,
    );
  }
}

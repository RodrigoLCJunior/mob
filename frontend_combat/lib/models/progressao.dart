class Progressao {
  final String id;
  final int totalMoedasTemporarias;
  final int totalCliques;
  final int totalInimigosDerrotados;
  final String avatarId; // Renomeado para evitar confusão com a classe Avatar

  Progressao({
    required this.id,
    required this.totalMoedasTemporarias,
    required this.totalCliques,
    required this.totalInimigosDerrotados,
    required this.avatarId,
  });

  factory Progressao.fromJson(Map<String, dynamic> json) {
    print('Progressao.fromJson - JSON: $json');
    return Progressao(
      id: json['id'] as String? ?? '',
      totalMoedasTemporarias: json['totalMoedasTemporarias'] as int? ?? 0,
      totalCliques: json['totalCliques'] as int? ?? 0,
      totalInimigosDerrotados: json['totalInimigosDerrotados'] as int? ?? 0,
      avatarId:
          json['avatar'] as String? ??
          '', // O JSON usa 'avatar' como uma String (o ID)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalMoedasTemporarias': totalMoedasTemporarias,
      'totalCliques': totalCliques,
      'totalInimigosDerrotados': totalInimigosDerrotados,
      'avatar': avatarId,
    };
  }

  // Método para atualizar os dados do usuário sem modificar a instância original
  Progressao copyWith({
    String? id,
    int? totalMoedasTemporarias,
    int? totalCliques,
    int? totalInimigosDerrotados,
    String? avatarId,
  }) {
    return Progressao(
      id: id ?? this.id,
      totalMoedasTemporarias:
          totalMoedasTemporarias ?? this.totalMoedasTemporarias,
      totalCliques: totalCliques ?? this.totalCliques,
      totalInimigosDerrotados:
          totalInimigosDerrotados ?? this.totalInimigosDerrotados,
      avatarId: avatarId ?? this.avatarId,
    );
  }
}

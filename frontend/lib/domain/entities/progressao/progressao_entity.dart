final class Progressao {
  final String id;
  final int totalMoedasTemporarias;
  final int totalCliques;
  final int totalInimigosDerrotados;
  final String avatarId;

  const Progressao({
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
      avatarId: json['avatar'] as String? ?? '',
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

  factory Progressao.fromMap(Map<String, dynamic> map) {
    return Progressao(
      id: map['id'] as String? ?? '',
      totalMoedasTemporarias: map['totalMoedasTemporarias'] as int? ?? 0,
      totalCliques: map['totalCliques'] as int? ?? 0,
      totalInimigosDerrotados: map['totalInimigosDerrotados'] as int? ?? 0,
      avatarId: map['avatar'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalMoedasTemporarias': totalMoedasTemporarias,
      'totalCliques': totalCliques,
      'totalInimigosDerrotados': totalInimigosDerrotados,
      'avatar': avatarId,
    };
  }

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

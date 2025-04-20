/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Entidade da Progressao
 ** Obs...:
 */

class Progressao {
  final String id;
  final int totalMoedasTemporarias;
  final int totalCliques;
  final int totalInimigosDerrotados;
  final String avatarId;

  Progressao({
    required this.id,
    required this.totalMoedasTemporarias,
    required this.totalCliques,
    required this.totalInimigosDerrotados,
    required this.avatarId,
  });

  factory Progressao.fromJson(Map<String, dynamic> json) {
    return Progressao(
      id: json['id'] as String,
      totalMoedasTemporarias: json['totalMoedasTemporarias'] as int,
      totalCliques: json['totalCliques'] as int,
      totalInimigosDerrotados: json['totalInimigosDerrotados'] as int,
      avatarId: json['avatarId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalMoedasTemporarias': totalMoedasTemporarias,
      'totalCliques': totalCliques,
      'totalInimigosDerrotados': totalInimigosDerrotados,
      'avatarId': avatarId,
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

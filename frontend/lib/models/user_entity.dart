/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 24/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criar a classe usuario
*/

class User {
  final String id;
  final String name;
  final int? coins;
  final int coinsId;
  final int lvl;
  final int exp;

  User({
    required this.id,
    required this.name,
    required this.coins,
    required this.coinsId,
    required this.lvl,
    required this.exp,
  });

  // Método para atualizar os dados do usuário sem modificar a instância original
  User copyWith({
    String? id,
    String? name,
    int? coins,
    int? coinsId,
    int? lvl,
    int? exp,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      coins: coins ?? this.coins,
      coinsId: coinsId ?? this.coinsId,
      lvl: lvl ?? this.lvl,
      exp: exp ?? this.exp,
    );
  }

  // Método para converter um JSON em um objeto User (útil para integração com banco)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      coins: json['coins'] ?? 0,
      coinsId: json['coinsId'] ?? 0,
      lvl: json['lvl'] ?? 1,
      exp: json['exp'] ?? 0,
    );
  }

  // Método para converter o objeto User em JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coins': coins,
      'coinsId': coinsId,
      'lvl': lvl,
      'exp': exp,
    };
  }
}

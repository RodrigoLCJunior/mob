class HabilidadeEntity {
  final int coins;
  final int initialCoins;
  final List<Map<String, dynamic>> talents;
  final String? userName;

  HabilidadeEntity({
    this.coins = 0,
    this.initialCoins = 0,
    this.talents = const [],
    this.userName,
  });

  HabilidadeEntity copyWith({
    int? coins,
    int? initialCoins,
    List<Map<String, dynamic>>? talents,
    String? userName,
  }) {
    return HabilidadeEntity(
      coins: coins ?? this.coins,
      initialCoins: initialCoins ?? this.initialCoins,
      talents: talents ?? this.talents,
      userName: userName ?? this.userName,
    );
  }
}

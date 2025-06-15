import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import '../fixture/library/fixture_helper.dart';

void main() {
  test('should validate the CombatInitialData entity', () async {
    // Arrange
    final Map<String, dynamic> map =
        FixtureHelper.fetchCombatInitialDataRemoteMap();

    // Act
    final CombatInitialData combatInitialData = CombatInitialData.fromJson(map);
    final CombatInitialData combatInitialDataCopy =
        CombatInitialData.fromJson(combatInitialData.toJson()).copyWith();

    // Assert
    expect(combatInitialData, isA<CombatInitialData>());
    expect(combatInitialDataCopy, isA<CombatInitialData>());
    expect(combatInitialDataCopy.enemy.id, 4);
    expect(combatInitialDataCopy.enemy.nome, "KARS");
    expect(combatInitialDataCopy.enemy.hp, 40);
    expect(combatInitialDataCopy.enemy.recompensa, 50);
    expect(combatInitialDataCopy.enemy.imageInimigo, "kars.png");
    expect(combatInitialDataCopy.enemy.deck, isNotNull);
    expect(combatInitialDataCopy.enemy.deck.length, 1);
    final enemyCards = combatInitialDataCopy.enemy.deck.first;
    expect(enemyCards.id, 1);
    expect(enemyCards.nome, "Right Punch");
    expect(enemyCards.descricao, "Aplica 2 pontos de dano físico.");
    expect(enemyCards.valor, 2);
    expect(enemyCards.qtdTurnos, 0);
    expect(enemyCards.imageCard, "right_punch.png");
    expect(enemyCards.tipoEfeito.name, "DANO");
    expect(combatInitialDataCopy.avatar.id, "teste");
    expect(combatInitialDataCopy.avatar.hp, 40);
    expect(combatInitialDataCopy.avatar.progressao!.id, "teste");
    expect(combatInitialDataCopy.avatar.progressao!.totalMoedasTemporarias, 0);
    expect(combatInitialDataCopy.avatar.progressao!.totalCliques, 0);
    expect(combatInitialDataCopy.avatar.progressao!.totalInimigosDerrotados, 0);
    expect(combatInitialDataCopy.avatar.progressao!.avatarId, "");
    expect(combatInitialDataCopy.avatar.deck.length, 1);
    final avatarCards = combatInitialDataCopy.avatar.deck.first;
    expect(avatarCards.id, 1);
    expect(avatarCards.nome, "Right Punch");
    expect(avatarCards.descricao, "Aplica 2 pontos de dano físico.");
    expect(avatarCards.valor, 2);
    expect(avatarCards.qtdTurnos, 0);
    expect(avatarCards.imageCard, "right_punch.png");
    expect(avatarCards.tipoEfeito.name, "DANO");
  });
}

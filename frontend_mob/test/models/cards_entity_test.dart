import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';
import '../fixture/library/fixture_helper.dart';

void main() {
  test('should validate the Cards entity', () async {
    // Arrange
    final Map<String, dynamic> map = FixtureHelper.fetchCardsRemoteMap();

    // Act
    final Cards cards = Cards.fromJson(map);
    final Cards cardsCopy = Cards.fromJson(cards.toJson()).copyWith();

    // Assert
    expect(cards, isA<Cards>());
    expect(cardsCopy, isA<Cards>());
    expect(cardsCopy.id, 1);
    expect(cardsCopy.nome, "Right Punch");
    expect(cardsCopy.descricao, "Aplica 2 pontos de dano físico.");
    expect(cardsCopy.valor, 2);
    expect(cardsCopy.qtdTurnos, 0);
    expect(cardsCopy.imageCard, "right_punch.png");
    expect(cardsCopy.tipoEfeito.name, "DANO");
  });
}

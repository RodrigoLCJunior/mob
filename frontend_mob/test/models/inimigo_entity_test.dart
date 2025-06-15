import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/domain/entities/inimigo/inimigo_entity.dart';

import '../fixture/library/fixture_helper.dart';

void main() {
  test('should validate the Inimigo entity', () async {
    // Arrange
    final Map<String, dynamic> map = FixtureHelper.fetchInimigoRemoteMap();

    // Act
    final Inimigo inimigo = Inimigo.fromJson(map);
    final Inimigo inimigoCopy = Inimigo.fromJson(inimigo.toJson()).copyWith();

    // Assert
    expect(inimigo, isA<Inimigo>());
    expect(inimigoCopy, isA<Inimigo>());
    expect(inimigoCopy.id, 3);
    expect(inimigoCopy.nome, "AHAB");
    expect(inimigoCopy.hp, 30);
    expect(inimigoCopy.recompensa, 30);
    expect(inimigoCopy.imageInimigo, "ahab.png");
    expect(inimigoCopy.deck, isNotNull);
    expect(inimigoCopy.deck.length, 1);
    final card = inimigoCopy.deck.first;
    expect(card.id, 8);
    expect(card.nome, "Ataque Venenoso");
    expect(card.descricao, "Aplica 2 de dano por rodada durante 2 turnos.");
    expect(card.valor, 2);
    expect(card.qtdTurnos, 2);
    expect(card.imageCard, "veneno.png");
    expect(card.tipoEfeito.name, "VENENO");
  });
}

/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 27/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criação de testes
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import '../fixture/library/fixture_helper.dart';

void main() {
  test('should valid the user entity', () {
    // Arrange
    final Map<String, dynamic> map = FixtureHelper.fetchUsuarioRemoteMap();

    // Act
    final Usuario user = Usuario.fromJson(map);
    final Usuario userCopy = Usuario.fromJson(user.toJson()).copyWith();

    // Assert
    /*expect(user, isA<User>());
    expect(userCopy, isA<User>());
    expect(userCopy.id, "100");
    expect(userCopy.nome, "teste");
    expect(userCopy.email, "teste");
    expect(userCopy.senha, "1234");
    expect(userCopy.dungeons?.length, 0);*/

    // Assert
    expect(user, isA<Usuario>());
    expect(userCopy, isA<Usuario>());

    expect(userCopy.id, "Teste");
    expect(userCopy.nome, "Rodrigo");
    expect(userCopy.email, "rodrigo@gmail.com");
    expect(userCopy.senha, "Teste");

    expect(userCopy.avatar, isNotNull);
    expect(userCopy.avatar!.id, "Teste");
    expect(userCopy.avatar!.hp, 40);
    expect(userCopy.avatar!.progressao, isNotNull);
    expect(userCopy.avatar!.progressao!.id, "Teste");
    expect(userCopy.avatar!.progressao!.totalMoedasTemporarias, 0);
    expect(userCopy.avatar!.progressao!.totalCliques, 0);
    expect(userCopy.avatar!.progressao!.totalInimigosDerrotados, 0);
    expect(userCopy.avatar!.progressao!.avatarId, "");

    expect(userCopy.avatar!.deck.length, 1);
    final card = userCopy.avatar!.deck.first;
    expect(card.id, 1);
    expect(card.nome, "Right Punch");
    expect(card.valor, 2);
    expect(card.tipoEfeito.name, "DANO");
    expect(card.qtdTurnos, 0);

    expect(userCopy.moedaPermanente, isNotNull);
    expect(userCopy.moedaPermanente!.id, "Teste");
    expect(userCopy.moedaPermanente!.quantidade, 0);
  });
}

/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 27/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criação de testes
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/models/user/user_entity.dart';
import '../fixture/library/fixture_helper.dart';

void main() {
  test('should valid the user entity', () {
    // Arrange
    final Map<String, dynamic> map = FixtureHelper.fetchUsuarioRemoteMap();

    // Act
    final User user = User.fromJson(map);
    final User userCopy = User.fromJson(user.toJson()).copyWith();

    // Assert
    expect(user, isA<User>());
    expect(userCopy, isA<User>());
    expect(userCopy.id, "100");
    expect(userCopy.nome, "teste");
    expect(userCopy.email, "teste");
    expect(userCopy.senha, "1234");
    expect(userCopy.dungeons?.length, 0);
  });
}

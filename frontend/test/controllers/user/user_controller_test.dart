/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 28/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criação de testes
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/models/user_entity.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';

void main() {
  setUp(() async {
    // Inicializa o SharedPreferences com valores simulados antes de cada teste
    SharedPreferences.setMockInitialValues({});
    await UserManager.clearUser(); // Garante que começa sem usuário salvo
  });

  test('should save and retrieve user from SharedPreferences', () async {
    // Arrange
    final user = User(
      id: '123',
      name: 'Jogador1',
      coins: 100,
      coinsId: 50,
      lvl: 5,
      exp: 200,
    );

    // Act
    await UserManager.saveUser(user);
    await UserManager.loadUser();

    // Assert
    expect(UserManager.currentUser, isNotNull);
    expect(UserManager.currentUser!.id, '123');
    expect(UserManager.currentUser!.name, 'Jogador1');
    expect(UserManager.currentUser!.coins, 100);
    expect(UserManager.currentUser!.coinsId, 50);
    expect(UserManager.currentUser!.lvl, 5);
    expect(UserManager.currentUser!.exp, 200);
  });

  test('should update user coins correctly', () async {
    // Arrange
    final user = User(
      id: '123',
      name: 'Jogador1',
      coins: 100,
      coinsId: 50,
      lvl: 5,
      exp: 200,
    );
    await UserManager.saveUser(user);

    // Act
    await UserManager.updateUserCoins(500);
    await UserManager.loadUser(); // Recarrega para confirmar a atualização

    // Assert
    expect(UserManager.currentUser!.coins, 500);
  });

  test('should remove user data from SharedPreferences', () async {
    // Arrange
    final user = User(
      id: '123',
      name: 'Jogador1',
      coins: 100,
      coinsId: 50,
      lvl: 5,
      exp: 200,
    );
    await UserManager.saveUser(user);

    // Act
    await UserManager.clearUser();

    // Assert
    await UserManager.loadUser();
    expect(UserManager.currentUser, isNull);
  });

  test('should set and retrieve user correctly', () async {
    // Arrange
    final user = User(
      id: '123',
      name: 'Jogador1',
      coins: 100,
      coinsId: 50,
      lvl: 5,
      exp: 200,
    );

    // Act
    await UserManager.setUser(user);
    await UserManager.loadUser();

    // Assert
    expect(UserManager.currentUser, isNotNull);
    expect(UserManager.currentUser!.id, '123');
    expect(UserManager.currentUser!.name, 'Jogador1');
  });
}

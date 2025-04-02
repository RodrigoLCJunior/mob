/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 27/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criação de testes
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/models/user_entity.dart';

void main() {
  group('User Entity Tests', () {
    test('deve criar uma instancia valida de usuario', () {
      // Arrange
      final usuario = User(
        id: '123',
        name: 'Jogador1',
        coins: 100,
        coinsId: 50,
        lvl: 5,
        exp: 200,
      );

      // Assert
      expect(usuario.id, '123');
      expect(usuario.name, 'Jogador1');
      expect(usuario.coins, 100);
      expect(usuario.coinsId, 50);
      expect(usuario.lvl, 5);
      expect(usuario.exp, 200);
    });

    test('deve validar os tipos da entidade usuario', () {
      // Arrange
      final usuario = User(
        id: '123',
        name: 'Jogador1',
        coins: 100,
        coinsId: 50,
        lvl: 5,
        exp: 200,
      );

      // Assert
      expect(usuario.id, isA<String>());
      expect(usuario.name, isA<String>());
      expect(usuario.coins, isA<int>());
      expect(usuario.coinsId, isA<int>());
      expect(usuario.lvl, isA<int>());
      expect(usuario.exp, isA<int>());
    });

    test('deve converter um JSON para um objeto usuario', () {
      // Arrange
      final json = {
        'id': '456',
        'name': 'Jogador2',
        'coins': 300,
        'coinsId': 150,
        'lvl': 10,
        'exp': 500,
      };

      // Act
      final usuario = User.fromJson(json);

      // Assert
      expect(usuario.id, '456');
      expect(usuario.name, 'Jogador2');
      expect(usuario.coins, 300);
      expect(usuario.coinsId, 150);
      expect(usuario.lvl, 10);
      expect(usuario.exp, 500);
    });

    test('deve converter um objeto usuario para um JSON', () {
      // Arrange
      final usuario = User(
        id: '789',
        name: 'Jogador3',
        coins: 500,
        coinsId: 250,
        lvl: 15,
        exp: 1000,
      );

      // Act
      final json = usuario.toJson();

      // Assert
      expect(json['id'], '789');
      expect(json['name'], 'Jogador3');
      expect(json['coins'], 500);
      expect(json['coinsId'], 250);
      expect(json['lvl'], 15);
      expect(json['exp'], 1000);
    });

    test('deve atualizar os dados do jogador utilizando a funcao copyWith', () {
      // Arrange
      final usuario = User(
        id: '111',
        name: 'JogadorAntigo',
        coins: 200,
        coinsId: 100,
        lvl: 7,
        exp: 300,
      );

      // Act
      final updatedUser = usuario.copyWith(name: 'JogadorNovo', coins: 500);

      // Assert
      expect(updatedUser.id, '111'); // Não alterado
      expect(updatedUser.name, 'JogadorNovo'); // Alterado
      expect(updatedUser.coins, 500); // Alterado
      expect(updatedUser.coinsId, usuario.coinsId); // Não alterado
      expect(updatedUser.lvl, usuario.lvl); // Não alterado
      expect(updatedUser.exp, usuario.exp); // Não alterado
    });
  });
}

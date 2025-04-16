/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 28/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criação de testes
*/

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/models/user/user_entity.dart';
import 'package:midnight_never_end/models/moeda_permanente/moeda_permanente_entity.dart';
import 'package:midnight_never_end/models/avatar/avatar_entity.dart';
import 'package:midnight_never_end/models/progressao/progressao_entity.dart';
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
      nome: 'Jogador1',
      email: 'jogador1@email.com',
      senha: 'senha123',
      avatar: Avatar(
        id: '123',
        hp: 5,
        danoBase: 1,
        progressao: Progressao(
          id: 'prog123',
          totalMoedasTemporarias: 0,
          totalCliques: 0,
          totalInimigosDerrotados: 0,
          avatarId: '123',
        ),
      ),
      moedaPermanente: MoedaPermanente(id: 'coin123', quantidade: 100),
    );

    // Act
    await UserManager.setUser(
      user,
    ); // Usando setUser, já que é o método usado no app
    await UserManager.loadUser();

    // Assert
    expect(UserManager.currentUser, isNotNull);
    expect(UserManager.currentUser!.id, '123');
    expect(UserManager.currentUser!.nome, 'Jogador1');
    expect(UserManager.currentUser!.email, 'jogador1@email.com');
    expect(UserManager.currentUser!.senha, 'senha123');
    expect(UserManager.currentUser!.avatar, isNotNull);
    expect(UserManager.currentUser!.avatar!.id, '123');
    expect(UserManager.currentUser!.avatar!.hp, 5);
    expect(UserManager.currentUser!.avatar!.danoBase, 1);
    expect(UserManager.currentUser!.avatar!.progressao, isNotNull);
    expect(UserManager.currentUser!.avatar!.progressao!.id, 'prog123');
    expect(
      UserManager.currentUser!.avatar!.progressao!.totalMoedasTemporarias,
      0,
    );
    expect(UserManager.currentUser!.avatar!.progressao!.totalCliques, 0);
    expect(
      UserManager.currentUser!.avatar!.progressao!.totalInimigosDerrotados,
      0,
    );
    expect(UserManager.currentUser!.avatar!.progressao!.avatarId, '123');
    expect(UserManager.currentUser!.moedaPermanente, isNotNull);
    expect(UserManager.currentUser!.moedaPermanente!.id, 'coin123');
    expect(UserManager.currentUser!.moedaPermanente!.quantidade, 100);
  });

  test('should update user coins correctly', () async {
    // Arrange
    final user = User(
      id: '123',
      nome: 'Jogador1',
      email: 'jogador1@email.com',
      senha: 'senha123',
      avatar: Avatar(
        id: '123',
        hp: 5,
        danoBase: 1,
        progressao: Progressao(
          id: 'prog123',
          totalMoedasTemporarias: 0,
          totalCliques: 0,
          totalInimigosDerrotados: 0,
          avatarId: '123',
        ),
      ),
      moedaPermanente: MoedaPermanente(id: 'coin123', quantidade: 100),
    );
    await UserManager.setUser(user);

    // Act
    final updatedUser = user.copyWith(
      moedaPermanente: user.moedaPermanente?.copyWith(quantidade: 500),
    );
    await UserManager.setUser(updatedUser); // Usando setUser pra atualizar
    await UserManager.loadUser();

    // Assert
    expect(UserManager.currentUser!.moedaPermanente!.quantidade, 500);
  });

  test('should remove user data from SharedPreferences', () async {
    // Arrange
    final user = User(
      id: '123',
      nome: 'Jogador1',
      email: 'jogador1@email.com',
      senha: 'senha123',
      avatar: Avatar(
        id: '123',
        hp: 5,
        danoBase: 1,
        progressao: Progressao(
          id: 'prog123',
          totalMoedasTemporarias: 0,
          totalCliques: 0,
          totalInimigosDerrotados: 0,
          avatarId: '123',
        ),
      ),
      moedaPermanente: MoedaPermanente(id: 'coin123', quantidade: 100),
    );
    await UserManager.setUser(user);

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
      nome: 'Jogador1',
      email: 'jogador1@email.com',
      senha: 'senha123',
      avatar: Avatar(
        id: '123',
        hp: 5,
        danoBase: 1,
        progressao: Progressao(
          id: 'prog123',
          totalMoedasTemporarias: 0,
          totalCliques: 0,
          totalInimigosDerrotados: 0,
          avatarId: '123',
        ),
      ),
      moedaPermanente: MoedaPermanente(id: 'coin123', quantidade: 100),
    );

    // Act
    await UserManager.setUser(user);
    await UserManager.loadUser();

    // Assert
    expect(UserManager.currentUser, isNotNull);
    expect(UserManager.currentUser!.id, '123');
    expect(UserManager.currentUser!.nome, 'Jogador1');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/models/user/user_entity.dart';
import 'package:midnight_never_end/models/moeda_permanente/moeda_permanente_entity.dart';
import 'package:midnight_never_end/controllers/user_controller.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await UserManager.clearUser();
  });

  test(
    'should execute a sequential flow for MoedaPermanente creation, persistence, and update',
    () async {
      // Passo 1: Criar e validar a entidade MoedaPermanente
      var moeda = MoedaPermanente(id: 'teste', quantidade: 0);

      expect(moeda, isA<MoedaPermanente>());
      expect(moeda.id, "teste");
      expect(moeda.quantidade, 0);

      // Passo 2: Associar a MoedaPermanente a um User e salvar no SharedPreferences
      final user = User(
        id: '123',
        nome: 'Jogador1',
        email: 'jogador1@email.com',
        senha: 'senha123',
        avatar: null, // Avatar não é necessário pra este teste
        moedaPermanente: moeda,
      );

      await UserManager.setUser(user);
      await UserManager.loadUser();

      expect(UserManager.currentUser, isNotNull);
      expect(UserManager.currentUser!.moedaPermanente, isNotNull);
      expect(UserManager.currentUser!.moedaPermanente!.id, "teste");
      expect(UserManager.currentUser!.moedaPermanente!.quantidade, 0);

      // Passo 3: Atualizar a quantidade de moedas e salvar novamente
      final updatedMoeda = moeda.copyWith(quantidade: 50);
      final updatedUser = user.copyWith(moedaPermanente: updatedMoeda);
      await UserManager.setUser(updatedUser);
      await UserManager.loadUser();

      expect(UserManager.currentUser!.moedaPermanente!.quantidade, 50);
      expect(
        UserManager.currentUser!.moedaPermanente!.id,
        "teste",
      ); // Garantir que o ID não mudou
    },
  );
}

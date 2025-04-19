import 'dart:convert';
import 'package:midnight_never_end/config/app_config.dart';

import '../../domain/entities/moeda_permanente/moeda_permanente_entity.dart';
import '../../domain/entities/user/user_entity.dart';

class UserManager {
  static User? currentUser;

  // Salvar usuário no SharedPreferences
  static Future<void> saveUser(User user) async {
    await AppConfig.sharedPreferences.setString(
      'user',
      jsonEncode(user.toJson()),
    ); // Converte para JSON e salva
    currentUser = user; // Atualiza a instância atual
  }

  // Carregar usuário do SharedPreferences
  static Future<void> loadUser() async {
    String? userData = AppConfig.sharedPreferences.getString('user');

    if (userData != null) {
      currentUser = User.fromJson(
        jsonDecode(userData),
      ); // Converte JSON para objeto
    }
  }

  // Definir usuário e salvar automaticamente
  static Future<void> setUser(User user) async {
    currentUser = user;
    await saveUser(user); // Salva no SharedPreferences
  }

  // Atualizar apenas as moedas permanentes do usuário
  static Future<void> updateUserCoins(int newCoins) async {
    if (currentUser != null) {
      // Atualiza o campo quantidade dentro de moedaPermanente
      final updatedMoedaPermanente =
          currentUser!.moedaPermanente?.copyWith(quantidade: newCoins) ??
          MoedaPermanente(
            id: "00000000-0000-0000-0000-000000000000",
            quantidade: newCoins,
          );
      currentUser = currentUser!.copyWith(
        moedaPermanente: updatedMoedaPermanente,
      );
      await saveUser(currentUser!); // Salva após a atualização
    }
  }

  // Remover usuário (logout)
  static Future<void> clearUser() async {
    await AppConfig.sharedPreferences.remove('user'); // Apaga os dados
    currentUser = null;
  }
}

/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 26/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criação de testes
*/

import 'dart:convert';
import 'package:midnight_never_end/models/moeda_permanente/moeda_permanente_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/models/user/user_entity.dart';

class UserManager {
  static User? currentUser;

  // Salvar usuário no SharedPreferences
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'user',
      jsonEncode(user.toJson()),
    ); // Converte para JSON e salva
    currentUser = user; // Atualiza a instância atual
  }

  // Carregar usuário do SharedPreferences
  static Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user');

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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user'); // Apaga os dados
    currentUser = null;
  }
}

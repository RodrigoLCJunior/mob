/*
 ** Task..: 9 - Tela de Cadastro do Usuario
 ** Data..: 16/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela de Cadastro para mobile e integração com backend (criando avatar)
 ** Obs...:
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

// Função para criar um avatar
Future<bool> criarAvatar(String avatarId, String userId) async {
  final avatarResponse = await http.post(
    Uri.parse("$supabaseUrl/avatar"),
    headers: {
      "Content-Type": "application/json",
      "apikey": apiKey,
    },
    body: jsonEncode({
      "id": avatarId,      // UUID único do avatar
      "dano_base": 1,     // Valor inicial
      "hp": 5,           // Valor inicial
      "usuario_id": userId, // Vinculado ao usuário
    }),
  );

  return avatarResponse.statusCode == 201;
}

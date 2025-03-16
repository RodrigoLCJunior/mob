/*
 ** Task..: 9 - Tela de Cadastro do Usuario
 ** Data..: 15/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela de Cadastro para mobile e integração com backend
 ** Obs...:
*/
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

// Função para criar um usuário
Future<bool> criarUsuario(String userId, String nome, String email, String senha, int moedaId) async {
  final userResponse = await http.post(
    Uri.parse("$supabaseUrl/usuarios"),
    headers: {
      "Content-Type": "application/json",
      "apikey": apiKey,
    },
    body: jsonEncode({
      "id": userId,
      "nome": nome,
      "email": email,
      "senha": senha,
      "nivel": 1,
      "moeda_permanente_id": moedaId,
    }),
  );

  return userResponse.statusCode == 201;
}

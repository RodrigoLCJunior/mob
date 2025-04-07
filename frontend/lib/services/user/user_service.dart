/*
 ** Task..: 9 - Tela de Cadastro do Usuario
 ** Data..: 15/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela de Cadastro para mobile e integração com backend
 ** Obs...:
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midnight_never_end/controllers/user_controller.dart';
import 'package:midnight_never_end/models/user/user_entity.dart';

const String _baseUrl =
    "http://localhost:9090/api/usuarios"; // Backend em 9090 no CHROME
//const String _baseUrl = "http://10.0.2.2:9090/api/usuarios";  // Backend em 9090 no EMULADOR

Future<Map<String, dynamic>> criarUsuario(
  String nome,
  String email,
  String senha,
) async {
  try {
    final userResponse = await http.post(
      Uri.parse("$_baseUrl/criar"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"nome": nome, "email": email, "senha": senha}),
    );

    print('Status Code: ${userResponse.statusCode}');
    print('Response Body: ${userResponse.body}');

    final responseData = jsonDecode(userResponse.body);
    return {
      "success": responseData['success'] as bool,
      "message": responseData['message'] as String,
    };
  } catch (e) {
    print('Erro na requisição: $e');
    return {"success": false, "message": "Erro de conexão com o servidor"};
  }
}

/* Task: 6 - 17/3 - Angelo Flavio Zanata */
Future<Map<String, dynamic>> fazerLogin(
  String email,
  String senhaDigitada,
) async {
  try {
    final response = await http.post(
      Uri.parse("$_baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "senha": senhaDigitada}),
    );

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    final responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final user = User.fromJson(responseData['user']);
      await UserManager.setUser(user);
      return {"success": true};
    } else {
      return {
        "success": false,
        "error": responseData['error'],
        "message": responseData['message'],
      };
    }
  } catch (e) {
    print('Erro na requisição: $e');
    return {
      "success": false,
      "error": "network",
      "message": "Erro de conexão com o servidor",
    };
  }
}

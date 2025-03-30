/*
 ** Task..: 9 - Tela de Cadastro do Usuario
 ** Data..: 15/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela de Cadastro para mobile e integração com backend
 ** Obs...:
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midnight_never_end/domain/entity/user/user_entity.dart';
import 'package:midnight_never_end/domain/managers/usuario_manager.dart';
import 'package:midnight_never_end/services/moeda_permanente_service.dart';
import 'auth_service.dart';
import 'package:bcrypt/bcrypt.dart';

// Função para criar um usuário
Future<bool> criarUsuario(String userId, String nome, String email, String senha, int moedaId) async {
  final senhaCriptografada = BCrypt.hashpw(senha, BCrypt.gensalt());

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
      "senha": senhaCriptografada,
      "nivel": 1,
      "moeda_permanente_id": moedaId,
    }),
  );

  return userResponse.statusCode == 201;
}

//
// Task: 6 - 17/3 - Angelo Flavio Zanata
//

Future<bool> fazerLogin(String email, String senhaDigitada) async {
  final response = await http.get(
    Uri.parse("$supabaseUrl/usuarios?email=eq.$email&select=id,senha,nome,moeda_permanente_id,nivel,experiencia"), // Busca por email e puxa nome e senha
    headers: {
      "apikey": apiKey,
    },
  );

  if (response.statusCode == 200 && jsonDecode(response.body).isNotEmpty) {

    final usuario = jsonDecode(response.body)[0];// Pega o primeiro resultado
    final senhaCorreta = BCrypt.checkpw(senhaDigitada, usuario['senha']); // 🔑 Compara senha digitada com hash
  
    if (senhaCorreta) {
      UserManager.setUser(User(
        id: usuario['id'], // O ID retornado pelo backend
        name: usuario['nome'],
        coins: await buscarMoeda(usuario['moeda_permanente_id']),
        coinsId: usuario['moeda_permanente_id'],
        lvl: usuario['nivel'],
        exp: usuario['experiencia'],
      ));
      return true;
    }
  }

  return false;
}

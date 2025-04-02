/*
 ** Task..: 9 - Tela de Cadastro do Usuario
 ** Data..: 15/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela de Cadastro para mobile e integração com backend (criando a moeda)
 ** Obs...:
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../auth_service.dart';

// Função para obter o maior ID disponível na tabela moeda_permanente
Future<int> obterMaiorIdMoeda() async {
  final moedaMaxIdResponse = await http.get(
    Uri.parse("$supabaseUrl/moeda_permanente?select=id&order=id.desc&limit=1"),
    headers: {"apikey": apiKey},
  );

  if (moedaMaxIdResponse.statusCode == 200 && jsonDecode(moedaMaxIdResponse.body).isNotEmpty) {
    final moedaData = jsonDecode(moedaMaxIdResponse.body);
    return (moedaData[0]['id'] as int) + 1;
  }
  return 1;
}

Future<bool> criarMoeda(int moedaId) async {
  final moedaResponse = await http.post(
    Uri.parse("$supabaseUrl/moeda_permanente"),
    headers: {
      "Content-Type": "application/json",
      "apikey": apiKey,
    },
    body: jsonEncode({
      "id": moedaId,
      "quantidade": 0,
    }),
  );

  return moedaResponse.statusCode == 201;
}

Future<int?> buscarMoeda(int moedaId) async {
  final moedaResponse = await http.get(
    Uri.parse("$supabaseUrl/moeda_permanente?id=eq.$moedaId&select=quantidade"),
    headers: {
      "apikey": apiKey,
    },
  );

  if (moedaResponse.statusCode == 200) {
    final List<dynamic> data = jsonDecode(moedaResponse.body);
    if (data.isNotEmpty) {
      return data[0]["quantidade"] as int;
    }
  }
  return null; // Retorna null se não encontrar a moeda
}


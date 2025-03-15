import 'dart:convert';
import 'package:http/http.dart' as http;

const String supabaseUrl = "https://cyepodycrzqdxxvsflvb.supabase.co/rest/v1";
const String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN5ZXBvZHljcnpxZHh4dnNmbHZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4NjIyNjYsImV4cCI6MjA1NjQzODI2Nn0.rAqIm0StF_iLcz_jhSEEKqrDShXXkGWbHYKGRhuQxcY";

// Função para obter o próximo ID disponível para moeda
Future<int> obterMaiorIdMoeda() async {
  final moedaMaxIdResponse = await http.get(
    Uri.parse("$supabaseUrl/moeda_permanente?select=id&order=id.desc&limit=1"),
    headers: {
      "apikey": apiKey,
    },
  );

  if (moedaMaxIdResponse.statusCode == 200 && jsonDecode(moedaMaxIdResponse.body).isNotEmpty) {
    final moedaData = jsonDecode(moedaMaxIdResponse.body);
    return (moedaData[0]['id'] as int) + 1; // Pega o maior ID e soma 1
  }
  
  return 1; // Se não encontrar nenhum(moeda), retorna 1
}

// Função para criar uma moeda na tabela moeda_permanente
Future<bool> criarMoeda(int moedaId) async {
  final moedaResponse = await http.post(
    Uri.parse("$supabaseUrl/moeda_permanente"),
    headers: {
      "Content-Type": "application/json",
      "apikey": apiKey,
    },
    body: jsonEncode({
      "id": moedaId, // ID calculado
      "quantidade": 1, // Quantidade inicial
    }),
  );

  return moedaResponse.statusCode == 201;
}

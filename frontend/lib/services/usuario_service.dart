import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tela_de_login/services/auth_service.dart';

const String supabaseUrl = "https://cyepodycrzqdxxvsflvb.supabase.co/rest/v1";
const String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN5ZXBvZHljcnpxZHh4dnNmbHZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4NjIyNjYsImV4cCI6MjA1NjQzODI2Nn0.rAqIm0StF_iLcz_jhSEEKqrDShXXkGWbHYKGRhuQxcY";

// Função para criar o usuário
Future<bool> criarUsuario(String nome, String email, String senha, int moedaId) async {
  final userResponse = await http.post(
    Uri.parse("$supabaseUrl/usuarios"),
    headers: {
      "Content-Type": "application/json",
      "apikey": apiKey,
    },
    body: jsonEncode({
      "id": userId, // UUID gerado de forma dinâmica
      "nome": nome,
      "email": email,
      "senha": senha,
      "nivel": 1,
      "moeda_permanente_id": moedaId, // ID único da moeda vinculada
    }),
  );

  return userResponse.statusCode == 201;
}

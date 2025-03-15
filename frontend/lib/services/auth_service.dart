import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'moeda_permanente_service.dart';
import 'usuario_service.dart';

const String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN5ZXBvZHljcnpxZHh4dnNmbHZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4NjIyNjYsImV4cCI6MjA1NjQzODI2Nn0.rAqIm0StF_iLcz_jhSEEKqrDShXXkGWbHYKGRhuQxcY";

const Uuid uuid = Uuid();
final String userId = uuid.v4();

// Função principal para cadastro do usuário
Future<void> cadastrarUsuario(BuildContext context, String nome, String email, String senha) async {
  try {
    
    final moedaId = await obterMaiorIdMoeda();// 1. Obter o próximo ID disponível para moeda

    
    final moedaCriada = await criarMoeda(moedaId);// 2. Criar a moeda
    if (!moedaCriada) {
      print("Erro ao criar moeda permanente(moeda_permanente_service.dart)");
      return;
    }

    
    final usuarioCriado = await criarUsuario(nome, email, senha, moedaId);// 3. Criar o usuário
    if (usuarioCriado) {
      print("Usuário cadastrado com sucesso!");
      Navigator.pop(context);// 4. Fechar o modal após sucesso
    } else print("Erro ao cadastrar usuário(usuario_service.dart)");

  } catch (e) {
    print("Erro inesperado(auth_service.dart): $e");
  }
}

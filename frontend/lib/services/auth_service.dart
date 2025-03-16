/*
 ** Task..: 9 - Tela de Cadastro do Usuario
 ** Data..: 14/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Criar tela de Cadastro para mobile e integração com backend
 ** Obs...:
*/
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'moeda_permanente_service.dart';
import 'usuario_service.dart';
import 'avatar_service.dart';

const Uuid uuid = Uuid();

const String apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN5ZXBvZHljcnpxZHh4dnNmbHZiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA4NjIyNjYsImV4cCI6MjA1NjQzODI2Nn0.rAqIm0StF_iLcz_jhSEEKqrDShXXkGWbHYKGRhuQxcY";
const String supabaseUrl = "https://cyepodycrzqdxxvsflvb.supabase.co/rest/v1";

Future<void> cadastrarUsuario(BuildContext context, String nome, String email, String senha) async {
  try {
    final String userId = uuid.v4(); // Gerar UUID para o usuário
    final int moedaId = await obterMaiorIdMoeda();
    
    final bool moedaCriada = await criarMoeda(moedaId);
    if (!moedaCriada) {
      print("Erro ao criar moeda permanente.(moeda_permanente_service.dart)");
      return;
    }

    final String avatarId = uuid.v4(); // Gerar UUID para o avatar
    
    
    final usuarioCriado = await criarUsuario(userId, nome, email, senha, moedaId); // 3. Criar o usuário
    if (usuarioCriado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: const Color.fromARGB(104, 23, 197, 0),
        ),
      );
      Navigator.pop(context); // 4. Fechar o modal após sucesso
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar usuário!'),
          backgroundColor: const Color.fromARGB(134, 163, 29, 20),
        ),
      );
    }
    
    final bool avatarCriado = await criarAvatar(avatarId, userId);
        if (!avatarCriado) {
          print("Erro ao criar avatar.(avatar_service.dart)");
          return;
        }
    
  } catch (e) {
    print("Erro inesperado:(auth_service.dart)$e");
  }
}

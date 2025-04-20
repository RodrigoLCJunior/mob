/*
 ** Task..: 30 - Padronização Frontend
 ** Data..: 26/03/2024
 ** Autor.: Angelo Flavio Zanata
 ** Motivo: Padronizar o frontend
 ** Obs...: Criação de testes
*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

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

class ApiConfig {
  static const String baseUrl =
      "https://mob-backend-ah3e.onrender.com/api/usuarios";
  static const int maxRetries = 2;
  static const Duration requestTimeout = Duration(seconds: 60);
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration pingTimeout = Duration(seconds: 5);
}

class BackendPinger {
  static bool _isPinging = false;
  static DateTime? _lastPing;
  static final logger = Logger();

  static Future<void> pingBackend() async {
    if (_isPinging ||
        (_lastPing != null &&
            DateTime.now().difference(_lastPing!).inSeconds < 30)) {
      return; // Evita ping se já foi feito recentemente
    }

    _isPinging = true;
    try {
      final stopwatch = Stopwatch()..start();
      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}/ping'))
          .timeout(ApiConfig.pingTimeout);
      stopwatch.stop();
      logger.d("Ping - Status: ${response.statusCode}");
      logger.d(
        "Ping - Tempo de resposta: ${stopwatch.elapsed.inMilliseconds / 1000} segundos",
      );
      if (response.statusCode == 200) {
        logger.i("Backend acordado com sucesso!");
      } else {
        logger.w("Ping retornou status inesperado: ${response.statusCode}");
      }
      _lastPing = DateTime.now();
    } catch (e) {
      logger.e("Erro ao fazer ping no backend: $e");
    } finally {
      _isPinging = false;
    }
  }
}

class UserService {
  Future<Map<String, dynamic>> criarUsuario(
    String nome,
    String email,
    String senha,
  ) async {
    final logger = Logger();

    // Validações básicas
    if (nome.isEmpty) {
      return {"success": false, "message": "Nome não pode estar vazio"};
    }
    if (email.isEmpty ||
        !RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        ).hasMatch(email)) {
      return {"success": false, "message": "Email inválido"};
    }
    if (senha.length < 6) {
      return {
        "success": false,
        "message": "Senha deve ter pelo menos 6 caracteres",
      };
    }

    await BackendPinger.pingBackend();

    for (int attempt = 1; attempt <= ApiConfig.maxRetries; attempt++) {
      try {
        final body = jsonEncode({'nome': nome, 'email': email, 'senha': senha});
        logger.d(
          "Tentativa $attempt - Enviando requisição para ${ApiConfig.baseUrl}/criar em ${DateTime.now()}",
        );
        logger.d("Body enviado: $body");
        final stopwatch = Stopwatch()..start();
        final response = await http
            .post(
              Uri.parse('${ApiConfig.baseUrl}/criar'),
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              body: body,
            )
            .timeout(ApiConfig.requestTimeout);
        stopwatch.stop();
        logger.d("Tentativa $attempt - Status: ${response.statusCode}");
        logger.d("Tentativa $attempt - Body recebido: ${response.body}");
        logger.d(
          "Tentativa $attempt - Tempo de resposta: ${stopwatch.elapsed.inSeconds} segundos",
        );

        Map<String, dynamic> responseData;
        try {
          responseData = jsonDecode(response.body);
        } catch (e) {
          return {
            "success": false,
            "message": "Resposta do servidor inválida: $e",
          };
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          return {
            "success": true,
            "message": responseData["message"] ?? "Cadastro feito com sucesso",
          };
        } else {
          return {
            "success": false,
            "message": responseData["message"] ?? "Erro ao cadastrar",
          };
        }
      } on http.ClientException catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == ApiConfig.maxRetries) {
          return {
            "success": false,
            "message":
                "Erro de conexão com o servidor após ${ApiConfig.maxRetries} tentativas: $e",
          };
        }
        await Future.delayed(ApiConfig.retryDelay);
      } on TimeoutException catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == ApiConfig.maxRetries) {
          return {
            "success": false,
            "message":
                "Tempo de resposta excedido após ${ApiConfig.maxRetries} tentativas: $e",
          };
        }
        await Future.delayed(ApiConfig.retryDelay);
      } catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == ApiConfig.maxRetries) {
          return {
            "success": false,
            "message":
                "Erro inesperado após ${ApiConfig.maxRetries} tentativas: $e",
          };
        }
        await Future.delayed(ApiConfig.retryDelay);
      }
    }
    return {"success": false, "message": "Falha inesperada"};
  }

  Future<Map<String, dynamic>> fazerLogin(
    String email,
    String senhaDigitada,
  ) async {
    final logger = Logger();

    // Validações básicas
    if (email.isEmpty ||
        !RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        ).hasMatch(email)) {
      return {"success": false, "message": "Email inválido"};
    }
    if (senhaDigitada.isEmpty) {
      return {"success": false, "message": "Senha não pode estar vazia"};
    }

    await BackendPinger.pingBackend();

    for (int attempt = 1; attempt <= ApiConfig.maxRetries; attempt++) {
      try {
        final body = jsonEncode({"email": email, "senha": senhaDigitada});
        logger.d(
          "Tentativa $attempt - Enviando requisição para ${ApiConfig.baseUrl}/login em ${DateTime.now()}",
        );
        logger.d("Body enviado: $body");
        final stopwatch = Stopwatch()..start();
        final response = await http
            .post(
              Uri.parse("${ApiConfig.baseUrl}/login"),
              headers: {"Content-Type": "application/json; charset=UTF-8"},
              body: body,
            )
            .timeout(ApiConfig.requestTimeout);
        stopwatch.stop();
        logger.d("Tentativa $attempt - Status: ${response.statusCode}");
        logger.d("Tentativa $attempt - Body recebido: ${response.body}");
        logger.d(
          "Tentativa $attempt - Tempo de resposta: ${stopwatch.elapsed.inSeconds} segundos",
        );

        Map<String, dynamic> responseData;
        try {
          responseData = jsonDecode(response.body);
        } catch (e) {
          return {
            "success": false,
            "message": "Resposta do servidor inválida: $e",
          };
        }

        if (response.statusCode == 200) {
          final user = User.fromJson(responseData['user']);
          await UserManager.setUser(user);
          return {"success": true, "user": user};
        } else {
          return {
            "success": false,
            "error": responseData['error'],
            "message": responseData['message'],
          };
        }
      } on http.ClientException catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == ApiConfig.maxRetries) {
          return {
            "success": false,
            "error": "network",
            "message":
                "Erro de conexão com o servidor após ${ApiConfig.maxRetries} tentativas: $e",
          };
        }
        await Future.delayed(ApiConfig.retryDelay);
      } on TimeoutException catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == ApiConfig.maxRetries) {
          return {
            "success": false,
            "error": "timeout",
            "message":
                "Tempo de resposta excedido após ${ApiConfig.maxRetries} tentativas: $e",
          };
        }
        await Future.delayed(ApiConfig.retryDelay);
      } catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == ApiConfig.maxRetries) {
          return {
            "success": false,
            "error": "unknown",
            "message":
                "Erro inesperado após ${ApiConfig.maxRetries} tentativas: $e",
          };
        }
        await Future.delayed(ApiConfig.retryDelay);
      }
    }
    return {"success": false, "message": "Falha inesperada"};
  }

  Future<void> logout() async {
    await UserManager.clearUser();
  }
}

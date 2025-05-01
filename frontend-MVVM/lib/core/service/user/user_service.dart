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
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserService {
  static const String baseUrl =
      "https://mob-backend-ah3e.onrender.com/api/usuarios";
  static const int maxRetries = 2;
  static const Duration requestTimeout = Duration(seconds: 60);
  static const Duration retryDelay = Duration(seconds: 2);
  static const Duration pingTimeout = Duration(seconds: 5);
  static const String userKey = 'user';

  final Logger logger = Logger();
  static bool _isPinging = false;
  static DateTime? _lastPing;
  User? _currentUser;

  UserService() {
    _loadUser();
  }

// Método público para inicializar o serviço e carregar o usuário
  Future<void> initialize() async {
    await _loadUser();
  }
  User? get currentUser => _currentUser;

  // Ping ao backend
  Future<void> _pingBackend() async {
    if (_isPinging ||
        (_lastPing != null &&
            DateTime.now().difference(_lastPing!).inSeconds < 30)) {
      return; // Evita ping se já foi feito recentemente
    }

    _isPinging = true;
    try {
      final stopwatch = Stopwatch()..start();
      final response = await http
          .get(Uri.parse('$baseUrl/ping'))
          .timeout(pingTimeout);
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

  // Salvar usuário no SharedPreferences
  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user.toJson()));
    _currentUser = user;
  }

  // Carregar usuário do SharedPreferences
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(userKey);
    if (userData != null) {
      _currentUser = User.fromJson(jsonDecode(userData));
    }
  }

  // Limpar usuário (logout)
  Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    _currentUser = null;
  }

  // Atualizar moedas do usuário
  Future<void> updateUserCoins(int newCoins) async {
    if (_currentUser != null) {
      final updatedMoedaPermanente =
          _currentUser!.moedaPermanente?.copyWith(quantidade: newCoins) ??
          MoedaPermanente(
            id: "00000000-0000-0000-0000-000000000000",
            quantidade: newCoins,
          );
      _currentUser = _currentUser!.copyWith(
        moedaPermanente: updatedMoedaPermanente,
      );
      await _saveUser(_currentUser!);
    } else {
      throw Exception("Nenhum usuário logado para atualizar moedas");
    }
  }

  // Fazer login
  Future<Map<String, dynamic>> login(String email, String password) async {
    // Validações básicas
    if (email.isEmpty ||
        !RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        ).hasMatch(email)) {
      return {"success": false, "message": "Email inválido"};
    }
    if (password.isEmpty) {
      return {"success": false, "message": "Senha não pode estar vazia"};
    }

    await _pingBackend();

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final body = jsonEncode({"email": email, "senha": password});
        logger.d(
          "Tentativa $attempt - Enviando requisição para $baseUrl/login em ${DateTime.now()}",
        );
        logger.d("Body enviado: $body");
        final stopwatch = Stopwatch()..start();
        final response = await http
            .post(
              Uri.parse("$baseUrl/login"),
              headers: {"Content-Type": "application/json; charset=UTF-8"},
              body: body,
            )
            .timeout(requestTimeout);
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
          await _saveUser(user);
          return {"success": true, "user": user};
        } else {
          return {
            "success": false,
            "message": responseData['message'] ?? "Erro ao fazer login",
          };
        }
      } on http.ClientException catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == maxRetries) {
          return {
            "success": false,
            "message":
                "Erro de conexão com o servidor após $maxRetries tentativas: $e",
          };
        }
        await Future.delayed(retryDelay);
      } on TimeoutException catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == maxRetries) {
          return {
            "success": false,
            "message":
                "Tempo de resposta excedido após $maxRetries tentativas: $e",
          };
        }
        await Future.delayed(retryDelay);
      } catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == maxRetries) {
          return {
            "success": false,
            "message": "Erro inesperado após $maxRetries tentativas: $e",
          };
        }
        await Future.delayed(retryDelay);
      }
    }
    return {"success": false, "message": "Falha inesperada"};
  }

  // Fazer cadastro
  Future<Map<String, dynamic>> register(
    String nome,
    String email,
    String password,
  ) async {
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
    if (password.length < 6) {
      return {
        "success": false,
        "message": "Senha deve ter pelo menos 6 caracteres",
      };
    }

    await _pingBackend();

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        final body = jsonEncode({
          'nome': nome,
          'email': email,
          'senha': password,
        });
        logger.d(
          "Tentativa $attempt - Enviando requisição para $baseUrl/criar em ${DateTime.now()}",
        );
        logger.d("Body enviado: $body");
        final stopwatch = Stopwatch()..start();
        final response = await http
            .post(
              Uri.parse('$baseUrl/criar'),
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              body: body,
            )
            .timeout(requestTimeout);
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
        if (attempt == maxRetries) {
          return {
            "success": false,
            "message":
                "Erro de conexão com o servidor após $maxRetries tentativas: $e",
          };
        }
        await Future.delayed(retryDelay);
      } on TimeoutException catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == maxRetries) {
          return {
            "success": false,
            "message":
                "Tempo de resposta excedido após $maxRetries tentativas: $e",
          };
        }
        await Future.delayed(retryDelay);
      } catch (e) {
        logger.e("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == maxRetries) {
          return {
            "success": false,
            "message": "Erro inesperado após $maxRetries tentativas: $e",
          };
        }
        await Future.delayed(retryDelay);
      }
    }
    return {"success": false, "message": "Falha inesperada"};
  }
}

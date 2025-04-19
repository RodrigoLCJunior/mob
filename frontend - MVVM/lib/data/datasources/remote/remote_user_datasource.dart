import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/entities/user/user_entity.dart';
import '../../../utils/logger.dart';
import '../../services/api_config.dart';
import '../../services/backend_pinger.dart';

abstract class RemoteUserDataSource {
  Future<Map<String, dynamic>> createUser(
    String nome,
    String email,
    String senha,
  );
  Future<Map<String, dynamic>> login(String email, String senha);
}

class RemoteUserDataSourceImpl implements RemoteUserDataSource {
  @override
  Future<Map<String, dynamic>> createUser(
    String nome,
    String email,
    String senha,
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
        Logger.log(
          "Tentativa $attempt - Enviando requisição para ${ApiConfig.baseUrl}/criar em ${DateTime.now()}",
        );
        Logger.log("Body enviado: $body");
        final stopwatch = Stopwatch()..start();
        final response = await http
            .post(
              Uri.parse('${ApiConfig.baseUrl}/criar'),
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              body: body,
            )
            .timeout(ApiConfig.requestTimeout);
        stopwatch.stop();
        Logger.log("Tentativa $attempt - Status: ${response.statusCode}");
        Logger.log("Tentativa $attempt - Body recebido: ${response.body}");
        Logger.log(
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
        Logger.error("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == ApiConfig.maxRetries) {
          return {
            "success": false,
            "message":
                "Erro de conexão com o servidor após ${ApiConfig.maxRetries} tentativas: $e",
          };
        }
        await Future.delayed(ApiConfig.retryDelay);
      } on TimeoutException catch (e) {
        Logger.error("Erro na tentativa $attempt em ${DateTime.now()}: $e");
        if (attempt == ApiConfig.maxRetries) {
          return {
            "success": false,
            "message":
                "Tempo de resposta excedido após ${ApiConfig.maxRetries} tentativas: $e",
          };
        }
        await Future.delayed(ApiConfig.retryDelay);
      } catch (e) {
        Logger.error("Erro na tentativa $attempt em ${DateTime.now()}: $e");
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

  @override
  Future<Map<String, dynamic>> login(String email, String senha) async {
    // Validações básicas
    if (email.isEmpty ||
        !RegExp(
          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
        ).hasMatch(email)) {
      return {"success": false, "message": "Email inválido"};
    }
    if (senha.isEmpty) {
      return {"success": false, "message": "Senha não pode estar vazia"};
    }

    await BackendPinger.pingBackend();

    for (int attempt = 1; attempt <= ApiConfig.maxRetries; attempt++) {
      try {
        final body = jsonEncode({"email": email, "senha": senha});
        Logger.log(
          "Tentativa $attempt - Enviando requisição para ${ApiConfig.baseUrl}/login em ${DateTime.now()}",
        );
        Logger.log("Body enviado: $body");
        final stopwatch = Stopwatch()..start();
        final response = await http
            .post(
              Uri.parse("${ApiConfig.baseUrl}/login"),
              headers: {"Content-Type": "application/json; charset=UTF-8"},
              body: body,
            )
            .timeout(ApiConfig.requestTimeout);
        stopwatch.stop();
        Logger.log("Tentativa $attempt - Status: ${response.statusCode}");
        Logger.log("Tentativa $attempt - Body recebido: ${response.body}");
        Logger.log(
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
          return {"success": true, "user": user};
        } else {
          return {
            "success": false,
            "error": responseData['error'],
            "message": responseData['message'],
          };
        }
      } on http.ClientException catch (e) {
        Logger.error("Erro na tentativa $attempt em ${DateTime.now()}: $e");
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
        Logger.error("Erro na tentativa $attempt em ${DateTime.now()}: $e");
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
        Logger.error("Erro na tentativa $attempt em ${DateTime.now()}: $e");
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
}

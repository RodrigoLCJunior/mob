import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midnight_never_end/config/api_config.dart';
import 'package:midnight_never_end/core/error/exceptions.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/user/user_entity.dart';

class BackendPinger {
  static bool _isPinging = false;
  static DateTime? _lastPing;

  BackendPinger();

  Future<void> pingBackend() async {
    if (_isPinging ||
        (_lastPing != null &&
            DateTime.now().difference(_lastPing!).inSeconds < 30)) {
      return; // Evita ping se já foi feito recentemente
    }

    _isPinging = true;
    try {
      final stopwatch = Stopwatch()..start();
      stopwatch.stop();
    } finally {
      _isPinging = false;
    }
  }
}

class UsuarioDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  final BackendPinger pinger;

  UsuarioDataSource({required this.client, required this.sharedPreferences})
    : pinger = BackendPinger();

  /// Função auxiliar para tratar respostas HTTP
  void _handleHttpResponse(
    http.Response response, {
    String defaultMessage = 'Erro desconhecido',
  }) {
    print('Status: ${response.statusCode}, Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return; // Sucesso
    }

    String errorMessage = defaultMessage;
    try {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      // Tenta capturar mensagens de erro em diferentes formatos
      errorMessage =
          responseData['message'] ??
          responseData['error'] ??
          responseData['detail'] ??
          'Erro ao processar resposta: status ${response.statusCode}';
    } catch (e) {
      // Se a decodificação falhar ou o corpo estiver vazio
      errorMessage =
          'Erro ao processar resposta: status ${response.statusCode}. Body: ${response.body}';
    }

    throw ServerException(message: errorMessage);
  }

  /// Cria um usuário no backend
  Future<void> criarUsuario(Usuario usuario) async {
    await pinger.pingBackend();

    print(
      'Tentando criar usuário: ${usuario.nome} com email: ${usuario.email}, senha: ${usuario.senha}',
    );

    for (int attempt = 1; attempt <= ApiConfig.maxRetries; attempt++) {
      try {
        final body = jsonEncode({
          'nome': usuario.nome,
          'email': usuario.email,
          'senha': usuario.senha,
        });
        print("Tentativa $attempt - Body enviado: $body");

        final response = await client
            .post(
              Uri.parse('${ApiConfig.baseUrl}/api/usuarios/criar'),
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              body: body,
            )
            .timeout(ApiConfig.requestTimeout);

        _handleHttpResponse(
          response,
          defaultMessage: 'Erro ao cadastrar usuário',
        );
        return; // Se chegou aqui, a criação foi bem-sucedida
      } on http.ClientException catch (e) {
        if (attempt == ApiConfig.maxRetries) {
          throw ServerException(message: 'Erro de conexão: $e');
        }
        await Future.delayed(ApiConfig.retryDelay);
      } on TimeoutException catch (e) {
        if (attempt == ApiConfig.maxRetries) {
          throw ServerException(message: 'Tempo de resposta excedido: $e');
        }
        await Future.delayed(ApiConfig.retryDelay);
      } catch (e) {
        if (attempt == ApiConfig.maxRetries) {
          throw ServerException(message: 'Erro inesperado: $e');
        }
        await Future.delayed(ApiConfig.retryDelay);
      }
    }
    throw ServerException(
      message: 'Falha inesperada após ${ApiConfig.maxRetries} tentativas',
    );
  }

  /// Faz login no backend
  Future<Usuario> fazerLogin(String email, String senha) async {
    print('Tentando fazer login com email: $email');
    await pinger.pingBackend();

    for (int attempt = 1; attempt <= ApiConfig.maxRetries; attempt++) {
      try {
        final body = jsonEncode({'email': email, 'senha': senha});
        final response = await client
            .post(
              Uri.parse('${ApiConfig.baseUrl}/api/usuarios/login'),
              headers: {'Content-Type': 'application/json; charset=UTF-8'},
              body: body,
            )
            .timeout(ApiConfig.requestTimeout);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          return Usuario.fromJson(responseData['user']);
        }

        _handleHttpResponse(response, defaultMessage: 'Erro ao fazer login');
      } on http.ClientException catch (e) {
        if (attempt == ApiConfig.maxRetries) {
          throw ServerException(message: 'Erro de conexão: $e');
        }
        await Future.delayed(ApiConfig.retryDelay);
      } on TimeoutException catch (e) {
        if (attempt == ApiConfig.maxRetries) {
          throw ServerException(message: 'Tempo de resposta excedido: $e');
        }
        await Future.delayed(ApiConfig.retryDelay);
      } catch (e) {
        if (attempt == ApiConfig.maxRetries) {
          throw ServerException(message: 'Erro inesperado: $e');
        }
        await Future.delayed(ApiConfig.retryDelay);
      }
    }
    throw ServerException(
      message: 'Falha inesperada após ${ApiConfig.maxRetries} tentativas',
    );
  }

  /// Salva o usuário localmente
  Future<void> saveUsuario(Usuario usuario) async {
    try {
      await sharedPreferences.setString('user', jsonEncode(usuario.toJson()));
    } catch (e) {
      throw ServerException(message: 'Erro ao salvar usuário localmente: $e');
    }
  }

  /// Carrega o usuário salvo localmente
  Future<Usuario?> carregarUsuario() async {
    try {
      final userData = sharedPreferences.getString('user');
      if (userData != null) {
        return Usuario.fromJson(jsonDecode(userData));
      }
      return null;
    } catch (e) {
      throw ServerException(message: 'Erro ao carregar usuário localmente: $e');
    }
  }

  /// Apaga o usuário localmente
  Future<void> apagarUsuario() async {
    try {
      await sharedPreferences.remove('user');
    } catch (e) {
      throw ServerException(message: 'Erro ao apagar usuário localmente: $e');
    }
  }
}

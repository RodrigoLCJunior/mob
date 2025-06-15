// lib/data/datasources/game_data_source.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midnight_never_end/config/api_config.dart';
import 'package:midnight_never_end/core/error/exceptions.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';

class GameDataSource {
  final http.Client client;
  GameDataSource({required this.client});

  /// Função auxiliar para tratar respostas HTTP (pode ser compartilhada)
  void _handleHttpResponse(
    http.Response response, {
    String defaultMessage = 'Erro desconhecido',
  }) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return; // Sucesso
    }

    String errorMessage = defaultMessage;
    try {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      errorMessage =
          responseData['message'] ??
          responseData['error'] ??
          responseData['detail'] ??
          'Erro ao processar resposta: status ${response.statusCode}';
    } catch (e) {
      errorMessage =
          'Erro ao processar resposta: status ${response.statusCode}. Body: ${response.body}';
    }

    throw ServerException(message: errorMessage);
  }

  /// Inicia o combate no backend
  Future<CombatInitialData> startCombat(String playerId) async {
    for (int attempt = 1; attempt <= ApiConfig.maxRetries; attempt++) {
      try {
        final response = await client
            .post(
              Uri.parse(
                '${ApiConfig.baseUrl}/api/combat/start?playerId=$playerId',
              ),
              headers: {'Content-Type': 'application/json'},
            )
            .timeout(ApiConfig.requestTimeout);

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          if (responseData['success'] == true) {
            return CombatInitialData.fromJson(responseData);
          } else {
            // Em vez de Exception, use ServerException para consistência
            throw ServerException(
              message:
                  responseData['message'] ??
                  'Erro desconhecido ao iniciar combate',
            );
          }
        }
        _handleHttpResponse(
          response,
          defaultMessage: 'Falha ao iniciar combate',
        );
      } on http.ClientException catch (e) {
        if (attempt == ApiConfig.maxRetries) {
          throw ServerException(
            message: 'Erro de conexão ao iniciar combate: $e',
          );
        }
        await Future.delayed(ApiConfig.retryDelay);
      } on TimeoutException catch (e) {
        if (attempt == ApiConfig.maxRetries) {
          throw ServerException(
            message: 'Tempo de resposta excedido ao iniciar combate: $e',
          );
        }
        await Future.delayed(ApiConfig.retryDelay);
      } catch (e) {
        if (attempt == ApiConfig.maxRetries) {
          throw ServerException(
            message: 'Erro inesperado ao iniciar combate: $e',
          );
        }
        await Future.delayed(ApiConfig.retryDelay);
      }
    }
    throw ServerException(
      message:
          'Falha inesperada ao iniciar combate após ${ApiConfig.maxRetries} tentativas',
    );
  }
}

// lib/data/repositories/game_repository.dart
import 'package:midnight_never_end/core/error/failures.dart';
import 'package:midnight_never_end/core/error/exceptions.dart';
import 'package:midnight_never_end/data/datasources/game/game_datasource.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';

class GameRepository {
  final GameDataSource dataSource;

  GameRepository({required this.dataSource});

  /// Inicia um novo combate para o jogador especificado
  Future<CombatInitialData> startCombat(String playerId) async {
    try {
      return await dataSource.startCombat(playerId);
    } on ServerException catch (e) {
      print('GameRepository Catch: $e (${e.runtimeType})');
      print('Mensagem recebida no catch: ${e.message}');
      throw ServerFailure(
        e.message,
      ); // Propaga a mensagem específica do ServerException como ServerFailure
    } catch (e) {
      print('GameRepository Catch: $e (${e.runtimeType})');
      throw ServerFailure('Erro inesperado ao iniciar combate: $e');
    }
  }
}

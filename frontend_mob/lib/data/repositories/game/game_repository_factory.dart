// lib/data/repositories/game_repository_factory.dart

import 'package:midnight_never_end/data/datasources/game/game_datasource_factory.dart';
import 'package:midnight_never_end/data/repositories/game/game_repository.dart';

class GameRepositoryFactory {
  /// Cria uma instância de GameRepository já configurada
  static Future<GameRepository> create() async {
    final gameDataSource = await GameDataSourceFactory.create();
    return GameRepository(dataSource: gameDataSource);
  }
}

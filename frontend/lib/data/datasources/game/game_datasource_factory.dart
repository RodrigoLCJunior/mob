// lib/data/datasources/game_data_source_factory.dart
import 'package:http/http.dart';
import 'package:midnight_never_end/data/datasources/game/game_datasource.dart';

class GameDataSourceFactory {
  /// Cria uma instância de GameDataSource já configurada
  static Future<GameDataSource> create() async {
    final client = Client();
    return GameDataSource(client: client);
  }
}

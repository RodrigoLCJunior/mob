import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/data/datasources/user/usuario_datasource.dart';

class UsuarioDataSourceFactory {
  /// Cria uma instância de UsuarioDataSource já configurada
  static Future<UsuarioDataSource> create() async {
    final client = Client();
    final sharedPreferences = await SharedPreferences.getInstance();
    return UsuarioDataSource(
      client: client,
      sharedPreferences: sharedPreferences,
    );
  }
}

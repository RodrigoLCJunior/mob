import 'package:http/http.dart';
import 'package:midnight_never_end/data/repositories/user/usuario_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/data/datasources/user/usuario_datasource.dart';

class UserRepositoryFactory {
  static Future<UserRepository> create() async {
    final client = Client();
    final sharedPreferences = await SharedPreferences.getInstance();
    final usuarioDataSource = UsuarioDataSource(
      client: client,
      sharedPreferences: sharedPreferences,
    );
    return UserRepository(dataSource: usuarioDataSource);
  }
}

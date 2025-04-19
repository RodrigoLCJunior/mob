import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/avatar/avatar_entity.dart';
import '../../../domain/entities/moeda_permanente/moeda_permanente_entity.dart';
import '../../../domain/entities/progressao/progressao_entity.dart';
import '../../../domain/entities/user/user_entity.dart';

class SharedPreferencesDataSource {
  final SharedPreferences _prefs;

  SharedPreferencesDataSource(this._prefs);

  // Métodos para User
  Future<User> getUser(String userId) async {
    final jsonString = _prefs.getString('user_$userId');
    if (jsonString == null) {
      throw Exception('Usuário não encontrado');
    }
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.fromJson(jsonMap);
  }

  Future<void> saveUser(User user) async {
    await _prefs.setString('user_${user.id}', jsonEncode(user.toJson()));
  }

  // Métodos para Avatar
  Future<Avatar> getAvatar(String avatarId) async {
    final jsonString = _prefs.getString('avatar_$avatarId');
    if (jsonString == null) {
      throw Exception('Avatar não encontrado');
    }
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return Avatar.fromJson(jsonMap);
  }

  Future<void> saveAvatar(Avatar avatar) async {
    await _prefs.setString('avatar_${avatar.id}', jsonEncode(avatar.toJson()));
  }

  // Métodos para MoedaPermanente
  Future<MoedaPermanente> getMoedaPermanente(String userId) async {
    final jsonString = _prefs.getString('moeda_permanente_$userId');
    if (jsonString == null) {
      throw Exception('Moeda permanente não encontrada');
    }
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return MoedaPermanente.fromJson(jsonMap);
  }

  Future<void> saveMoedaPermanente(MoedaPermanente moeda) async {
    await _prefs.setString(
      'moeda_permanente_${moeda.id}',
      jsonEncode(moeda.toJson()),
    );
  }

  // Métodos para Progressao
  Future<Progressao> getProgressao(String progressaoId) async {
    final jsonString = _prefs.getString('progressao_$progressaoId');
    if (jsonString == null) {
      throw Exception('Progressão não encontrada');
    }
    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return Progressao.fromJson(jsonMap);
  }

  Future<void> saveProgressao(Progressao progressao) async {
    await _prefs.setString(
      'progressao_${progressao.id}',
      jsonEncode(progressao.toJson()),
    );
  }
}

import 'dart:convert';

import 'package:midnight_never_end/models/avatar/avatar_entity.dart';
import 'package:midnight_never_end/models/moeda_permanente/moeda_permanente_entity.dart';
import 'package:midnight_never_end/models/progressao/progressao_entity.dart';
import 'package:midnight_never_end/models/user/user_entity.dart';

import 'fixture_reader.dart';

final class FixtureHelper {
  static const String url = 'https://test.com.br';

  //User
  static User fetchUsuario() {
    return User.fromJson(jsonDecode(fixture('user.json')));
  }

  static Map<String, dynamic> fetchUsuarioRemoteMap() {
    return jsonDecode(fixture('user.json'));
  }

  //Avatar
  static Avatar fetchAvatar() {
    return Avatar.fromJson(jsonDecode(fixture('avatar.json')));
  }

  static Map<String, dynamic> fetchAvatarRemoteMap() {
    return jsonDecode(fixture('avatar.json'));
  }

  //Progressao
  static Progressao fetchProgressao() {
    return Progressao.fromJson(jsonDecode(fixture('progressao.json')));
  }

  static Map<String, dynamic> fetchProgressaoRemoteMap() {
    return jsonDecode(fixture('progressao.json'));
  }

  //Moeda Permanente
  static MoedaPermanente fetchMoedaPermanente() {
    return MoedaPermanente.fromJson(
      jsonDecode(fixture('moeda_permanente.json')),
    );
  }

  static Map<String, dynamic> fetchMoedaPermanenteRemoteMap() {
    return jsonDecode(fixture('moeda_permanente.json'));
  }
}

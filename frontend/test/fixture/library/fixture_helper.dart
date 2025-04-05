import 'dart:convert';

import 'package:midnight_never_end/models/user/user_entity.dart';


import 'fixture_reader.dart';

final class FixtureHelper {
  static const String url = 'https://test.com.br';

  static User fetchUsuario() {
    return User.fromJson(jsonDecode(fixture('user.json')));
  }

  static Map<String, dynamic> fetchUsuarioRemoteMap() {
    return jsonDecode(fixture('user.json'));
  }
}

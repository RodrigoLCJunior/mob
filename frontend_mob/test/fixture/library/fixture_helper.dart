import 'dart:convert';

import 'package:midnight_never_end/domain/entities/avatar/avatar_entity.dart';
import 'package:midnight_never_end/domain/entities/cards/cards_entity.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import 'package:midnight_never_end/domain/entities/inimigo/inimigo_entity.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';
import 'package:midnight_never_end/domain/entities/progressao/progressao_entity.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';

import 'fixture_reader.dart';

final class FixtureHelper {
  static const String url = 'https://test.com.br';

  //User
  static Usuario fetchUsuario() {
    return Usuario.fromJson(jsonDecode(fixture('user.json')));
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

  //Cards
  static Cards fetchCards() {
    return Cards.fromJson(jsonDecode(fixture('cards.json')));
  }

  static Map<String, dynamic> fetchCardsRemoteMap() {
    return jsonDecode(fixture('cards.json'));
  }

  //Combate
  static CombatInitialData fetchCombatInitialData() {
    return CombatInitialData.fromJson(
      jsonDecode(fixture('combat_initial_data.json')),
    );
  }

  static Map<String, dynamic> fetchCombatInitialDataRemoteMap() {
    return jsonDecode(fixture('combat_initial_data.json'));
  }

  //Inimigo
  static Inimigo fetchInimigo() {
    return Inimigo.fromJson(jsonDecode(fixture('inimigo.json')));
  }

  static Map<String, dynamic> fetchInimigoRemoteMap() {
    return jsonDecode(fixture('inimigo.json'));
  }
}

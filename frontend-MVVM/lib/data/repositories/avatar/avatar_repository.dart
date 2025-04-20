/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Repositorio de Metodos do Avatar
 ** Obs...:
 */

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/domain/entities/avatar/avatar_entity.dart';

class AvatarRepository {
  Future<void> saveAvatar(Avatar avatar) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'avatar',
      jsonEncode(avatar.toJson()),
    ); // Converte para JSON e salva
  }

  Future<Avatar?> loadAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarData = prefs.getString('avatar');

    if (avatarData != null) {
      return Avatar.fromJson(
        jsonDecode(avatarData),
      ); // Converte JSON para objeto
    }
    return null;
  }

  Future<void> clearAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('avatar'); // Remove o avatar salvo
  }
}

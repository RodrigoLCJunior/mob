/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Repositorio de Metodos do Progressao
 ** Obs...:
 */

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/domain/entities/progressao/progressao_entity.dart';

class ProgressaoRepository {
  Future<void> saveProgressao(Progressao progressao) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'progressao',
      jsonEncode(progressao.toJson()),
    ); // Salva como JSON
  }

  Future<Progressao?> loadProgressao() async {
    final prefs = await SharedPreferences.getInstance();
    final progressaoData = prefs.getString('progressao');

    if (progressaoData != null) {
      return Progressao.fromJson(
        jsonDecode(progressaoData),
      ); // Converte JSON para objeto
    }
    return null;
  }

  Future<void> clearProgressao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('progressao'); // Remove os dados salvos
  }
}

/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Repositorio de Metodos do Moeda Permanente
 ** Obs...:
 */

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';

class MoedaPermanenteRepository {
  Future<void> saveMoeda(MoedaPermanente moeda) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'moeda_permanente',
      jsonEncode(moeda.toJson()),
    ); // Salva como JSON
  }

  Future<MoedaPermanente?> loadMoeda() async {
    final prefs = await SharedPreferences.getInstance();
    final moedaData = prefs.getString('moeda_permanente');

    if (moedaData != null) {
      return MoedaPermanente.fromJson(
        jsonDecode(moedaData),
      ); // Converte JSON para objeto
    }
    return null;
  }

  Future<void> clearMoeda() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('moeda_permanente'); // Remove os dados salvos
  }
}

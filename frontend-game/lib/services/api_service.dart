import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:midnight_never_end/models/combat_initial_data.dart';
import 'package:midnight_never_end/models/inimigo.dart';
import 'package:midnight_never_end/models/usuario.dart';
import 'package:midnight_never_end/models/dungeon.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:9090/api';
  //static const String baseUrl = 'https://mob-backend-3-combate-inteiro.onrender.com/api';

  Future<Usuario> login(String email, String senha) async {
    try {
      print('Attempting login for $email');
      final response = await http.post(
        Uri.parse('$baseUrl/usuarios/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      print('Login - Status Code: ${response.statusCode}');
      print('Login - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['user'] != null) {
          final usuario = Usuario.fromJson(responseData['user']);
          print('Parsed usuario ID: ${usuario.id}');
          return usuario;
        } else {
          throw Exception(
            'Login failed: ${responseData['error'] ?? 'Unknown error'}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Email não encontrado: ${response.body}');
      } else if (response.statusCode == 401) {
        throw Exception('Senha incorreta: ${response.body}');
      } else {
        throw Exception(
          'Erro no servidor: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e, stackTrace) {
      print('Exception during login: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<Usuario> fetchUsuarioByEmailDirect(String email) async {
    try {
      print('Fetching usuario directly by email: $email');
      final response = await http.get(
        Uri.parse('$baseUrl/usuarios/email?email=$email'),
        headers: {'Content-Type': 'application/json'},
      );
      print('FetchUsuarioByEmailDirect - Status Code: ${response.statusCode}');
      print('FetchUsuarioByEmailDirect - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true && responseData['user'] != null) {
          final usuario = Usuario.fromJson(responseData['user']);
          print('FetchUsuarioByEmailDirect - Parsed usuario: ${usuario.id}');
          return usuario;
        } else {
          throw Exception(
            'Fetch failed: ${responseData['error'] ?? 'Unknown error'}',
          );
        }
      } else if (response.statusCode == 404) {
        throw Exception('Usuário não encontrado para o email: $email');
      } else {
        throw Exception(
          'Failed to load usuario by email: HTTP ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Exception during fetchUsuarioByEmailDirect: $e');
      throw Exception('Failed to load usuario by email: $e');
    }
  }

  Future<Usuario> fetchUsuarioById(String id) async {
    try {
      print('Fetching usuario with ID: $id');
      final response = await http.get(Uri.parse('$baseUrl/usuarios/$id'));
      print('FetchUsuarioById - Status Code: ${response.statusCode}');
      print('FetchUsuarioById - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final usuario = Usuario.fromJson(jsonDecode(response.body));
        print('FetchUsuarioById - Parsed usuario: ${usuario.id}');
        return usuario;
      } else {
        throw Exception(
          'Failed to load usuario: HTTP ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Exception during fetchUsuarioById: $e');
      throw Exception('Failed to load usuario: $e');
    }
  }

  Future<Inimigo> fetchFirstInimigo() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/inimigos'));
      print('FetchFirstInimigo - Status Code: ${response.statusCode}');
      print('FetchFirstInimigo - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        if (jsonList.isNotEmpty) {
          return Inimigo.fromJson(jsonList.first as Map<String, dynamic>);
        } else {
          throw Exception('No inimigos found');
        }
      } else {
        throw Exception(
          'Failed to load inimigos: HTTP ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Exception during fetchFirstInimigo: $e');
      throw Exception('Failed to load inimigos: $e');
    }
  }

  Future<CombatInitialData> startCombat(String playerId) async {
    try {
      print('Starting combat for playerId: $playerId');
      final response = await http.post(
        Uri.parse('$baseUrl/combat/start?playerId=$playerId'),
        headers: {'Content-Type': 'application/json'},
      );
      print('StartCombat - Status Code: ${response.statusCode}');
      print('StartCombat - Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          return CombatInitialData.fromJson(responseData['combatState'] ?? {});
        } else {
          throw Exception(
            'Start combat failed: ${responseData['message'] ?? 'Unknown error'}',
          );
        }
      } else if (response.statusCode == 400) {
        throw Exception('Bad request: ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Player not found: ${response.body}');
      } else {
        throw Exception(
          'Failed to start combat: HTTP ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Exception during startCombat: $e');
      throw Exception('Failed to start combat: $e');
    }
  }

  Future<CombatInitialData> startDungeon(String playerId, int dungeonId) async {
  try {
    print('Starting dungeon for playerId: $playerId and dungeonId: $dungeonId');
    final response = await http.post(
      Uri.parse('$baseUrl/combat/start-dungeon?playerId=$playerId&dungeonId=$dungeonId'),
      // Remova o header:
      // headers: {'Content-Type': 'application/json'}, ❌
    );

    print('StartDungeon - Status Code: ${response.statusCode}');
    print('StartDungeon - Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        return CombatInitialData.fromJson(responseData['combatState'] ?? {}); // 👈 aqui
      } else {
        throw Exception('Start dungeon failed: ${responseData['message'] ?? 'Unknown error'}');
      }
    } else {
      throw Exception(
        'Failed to start dungeon: HTTP ${response.statusCode} - ${response.body}',
      );
    }
  } catch (e) {
    print('Exception during startDungeon: $e');
    throw Exception('Failed to start dungeon: $e');
  }
}

Future<Dungeon> fetchDungeonById(int id) async {
  final response = await http.get(Uri.parse('$baseUrl/dungeon/$id'));
  if (response.statusCode == 200) {
    final json = jsonDecode(response.body);
    return Dungeon.fromJson(json);
  } else {
    throw Exception('Erro ao buscar dungeon: ${response.body}');
  }
}

Future<CombatInitialData> nextWave(String playerId) async {
  try {
    print('Requesting next wave for playerId: $playerId');
    final response = await http.post(
      Uri.parse('$baseUrl/combat/next-wave?playerId=$playerId'),
      headers: {'Content-Type': 'application/json'},
    );

    print('NextWave - Status Code: ${response.statusCode}');
    print('NextWave - Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['success'] == true) {
        return CombatInitialData.fromJson(responseData['combatState'] ?? {});
      } else {
        throw Exception(
          'Next wave failed: ${responseData['message'] ?? 'Unknown error'}',
        );
      }
    } else {
      throw Exception(
        'Failed to load next wave: HTTP ${response.statusCode} - ${response.body}',
      );
    }
  } catch (e) {
    print('Exception during nextWave: $e');
    throw Exception('Failed to load next wave: $e');
  }
}




}

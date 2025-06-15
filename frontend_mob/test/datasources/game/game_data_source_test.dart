import 'dart:convert';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:midnight_never_end/data/datasources/game/game_datasource.dart';
import 'package:mocktail/mocktail.dart';
import 'package:midnight_never_end/domain/entities/combat/combat_initial_data.dart';
import 'package:midnight_never_end/core/error/exceptions.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late GameDataSource dataSource;
  late MockHttpClient mockClient;

  // REGISTRA O URI FICTÍCIO
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    dataSource = GameDataSource(client: mockClient);
  });

  group('startCombat', () {
    const playerId = '123';

    test(
      'deve retornar CombatInitialData quando status 200 e success true',
      () async {
        // Arrange
        final mockResponseData = {
          'success': true,
          'combatData': {'turnoAtual': 1},
          'avatar': {'id': 'Teste', 'hp': 40, 'progressao': {}, 'deck': []},
          'enemy': {
            'id': 1,
            'nome': 'Teste',
            'hp': 20,
            'recompensa': 50,
            'imageInimigo': 'Teste',
            'deck': [],
          },
        };

        when(
          () => mockClient.post(any(), headers: any(named: 'headers')),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode(mockResponseData), 200),
        );

        // Act
        final result = await dataSource.startCombat(playerId);

        // Assert
        expect(result, isA<CombatInitialData>());
      },
    );

    test('deve lançar ServerException quando status != 200', () async {
      when(
        () => mockClient.post(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response('Erro', 400));

      expect(
        () => dataSource.startCombat(playerId),
        throwsA(isA<ServerException>()),
      );
    });

    test('deve lançar ServerException se success != true', () async {
      final response = {'success': false, 'message': 'Combate não autorizado'};

      when(
        () => mockClient.post(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => http.Response(jsonEncode(response), 200));

      expect(
        () => dataSource.startCombat(playerId),
        throwsA(isA<ServerException>()),
      );
    });

    test('deve lançar ServerException em TimeoutException', () async {
      when(
        () => mockClient.post(any(), headers: any(named: 'headers')),
      ).thenThrow(TimeoutException('timeout'));

      expect(
        () => dataSource.startCombat(playerId),
        throwsA(isA<ServerException>()),
      );
    });

    test('deve lançar ServerException em ClientException', () async {
      when(
        () => mockClient.post(any(), headers: any(named: 'headers')),
      ).thenThrow(http.ClientException('client error'));

      expect(
        () => dataSource.startCombat(playerId),
        throwsA(isA<ServerException>()),
      );
    });
  });
}

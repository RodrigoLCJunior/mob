import 'dart:convert';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:midnight_never_end/data/datasources/user/usuario_datasource.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:midnight_never_end/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late UsuarioDataSource dataSource;
  late MockHttpClient mockClient;
  late MockSharedPreferences mockPrefs;

  const email = 'teste@email.com';
  const senha = '123456';

  final fakeUserJson = {
    'id': 'abc123',
    'nome': 'Teste',
    'email': email,
    'senha': senha,
    'avatar': null,
  };

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockClient = MockHttpClient();
    mockPrefs = MockSharedPreferences();
    dataSource = UsuarioDataSource(
      client: mockClient,
      sharedPreferences: mockPrefs,
    );
  });

  group('fazerLogin', () {
    test(
      'deve retornar Usuario se o login for bem-sucedido (status 200)',
      () async {
        when(
          () => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          ),
        ).thenAnswer(
          (_) async => http.Response(jsonEncode({'user': fakeUserJson}), 200),
        );

        final usuario = await dataSource.fazerLogin(email, senha);

        expect(usuario, isA<Usuario>());
        expect(usuario.email, equals(email));
      },
    );

    test('deve lançar ServerException se status != 200', () async {
      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => http.Response('Erro', 401));

      expect(
        () => dataSource.fazerLogin(email, senha),
        throwsA(isA<ServerException>()),
      );
    });

    test('deve lançar ServerException em TimeoutException', () async {
      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenThrow(TimeoutException('Timeout'));

      expect(
        () => dataSource.fazerLogin(email, senha),
        throwsA(isA<ServerException>()),
      );
    });

    test('deve lançar ServerException em ClientException', () async {
      when(
        () => mockClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenThrow(http.ClientException('Erro'));

      expect(
        () => dataSource.fazerLogin(email, senha),
        throwsA(isA<ServerException>()),
      );
    });
  });
}

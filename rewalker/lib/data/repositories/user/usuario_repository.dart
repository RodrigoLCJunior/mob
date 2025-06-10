import 'package:midnight_never_end/core/error/exceptions.dart';
import 'package:midnight_never_end/core/error/failures.dart';
import 'package:midnight_never_end/data/datasources/user/usuario_datasource.dart';
import 'package:midnight_never_end/domain/entities/user/user_entity.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';

class UserRepository {
  final UsuarioDataSource dataSource;

  UserRepository({required this.dataSource});

  /// Cria um novo usuário no backend
  Future<void> criarUsuario({
    required String nome,
    required String email,
    required String senha,
  }) async {
    try {
      await dataSource.criarUsuario(
        Usuario(
          id: '', // ID será gerado pelo backend
          nome: nome,
          email: email,
          senha: senha,
        ),
      );
    } on ServerException catch (e) {
      print('Repository Catch: $e (${e.runtimeType})');
      print('Mensagem recebida no catch: ${e.message}');
      throw ServerFailure(
        e.message,
      ); // Propaga a mensagem específica do ServerException
    } catch (e) {
      print('Repository Catch: $e (${e.runtimeType})');
      throw ServerFailure('Erro inesperado: $e');
    }
  }

  /// Faz login e salva o usuário localmente
  Future<Usuario> fazerLogin(String email, String senha) async {
    try {
      final usuario = await dataSource.fazerLogin(email, senha);
      await dataSource.saveUsuario(usuario); // Salva no celular
      return usuario;
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Erro inesperado: $e');
    }
  }

  /// Carrega o usuário salvo no celular
  Future<Usuario?> carregarUsuario() async {
    try {
      return await dataSource.carregarUsuario();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Erro inesperado: $e');
    }
  }

  /// Apaga o usuário do celular (logout)
  Future<void> logout() async {
    try {
      await dataSource.apagarUsuario();
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Erro inesperado: $e');
    }
  }

  /// Atualiza as moedas permanentes do usuário
  Future<void> atualizarMoedas(int novasMoedas) async {
    try {
      final usuario = await dataSource.carregarUsuario();
      if (usuario != null) {
        final updatedMoedaPermanente =
            usuario.moedaPermanente?.copyWith(quantidade: novasMoedas) ??
            MoedaPermanente(
              id: "00000000-0000-0000-0000-000000000000",
              quantidade: novasMoedas,
            );
        final updatedUsuario = usuario.copyWith(
          moedaPermanente: updatedMoedaPermanente,
        );
        await dataSource.saveUsuario(updatedUsuario);
      }
    } on ServerException catch (e) {
      throw ServerFailure(e.message);
    } catch (e) {
      throw ServerFailure('Erro inesperado: $e');
    }
  }
}

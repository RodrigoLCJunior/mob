import 'package:dartz/dartz.dart';
import 'package:midnight_never_end/domain/error/user/user_failure.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/user/user_entity.dart';
import '../../../domain/repositories/user/user_repository.dart';
import '../../datasources/core/shared_preferences_datasource.dart';
import '../../datasources/remote/remote_user_datasource.dart';
import '../../services/user_manager.dart';

class UserRepositoryImpl implements UserRepository {
  final SharedPreferencesDataSource localDataSource;
  final RemoteUserDataSource remoteDataSource;

  UserRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Failure, User>> getUser(String userId) async {
    try {
      final user = await localDataSource.getUser(userId);
      return Right(user);
    } catch (e) {
      return Left(UserFailure('Erro ao buscar usuário: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(User user) async {
    try {
      await localDataSource.saveUser(user);
      await UserManager.setUser(user); // Atualiza o currentUser
      return Right(user);
    } catch (e) {
      return Left(UserFailure('Erro ao atualizar usuário: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> createUser(
    String nome,
    String email,
    String senha,
  ) async {
    try {
      final result = await remoteDataSource.createUser(nome, email, senha);
      if (result['success'] == true) {
        return const Right(null);
      } else {
        return Left(UserFailure(result['message'] ?? 'Erro ao criar usuário'));
      }
    } catch (e) {
      return Left(UserFailure('Erro ao criar usuário: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> login(String email, String senha) async {
    try {
      final result = await remoteDataSource.login(email, senha);
      if (result['success'] == true) {
        final user = result['user'] as User;
        await UserManager.setUser(user); // Salva o usuário localmente
        return Right(user);
      } else {
        return Left(UserFailure(result['message'] ?? 'Erro ao fazer login'));
      }
    } catch (e) {
      return Left(UserFailure('Erro ao fazer login: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await UserManager.clearUser();
      return const Right(null);
    } catch (e) {
      return Left(UserFailure('Erro ao fazer logout: ${e.toString()}'));
    }
  }
}

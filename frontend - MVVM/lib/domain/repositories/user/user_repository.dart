import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../entities/user/user_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> getUser(String userId);
  Future<Either<Failure, User>> updateUser(User user);
  Future<Either<Failure, void>> createUser(
    String nome,
    String email,
    String senha,
  );
  Future<Either<Failure, User>> login(String email, String senha);
  Future<Either<Failure, void>> logout();
}

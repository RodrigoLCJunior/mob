import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/user/user_repository.dart';

class LoginUser implements UseCase<User, LoginUserParams> {
  final UserRepository repository;

  const LoginUser(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginUserParams params) async {
    return await repository.login(params.email, params.senha);
  }
}

class LoginUserParams {
  final String email;
  final String senha;

  LoginUserParams({required this.email, required this.senha});
}

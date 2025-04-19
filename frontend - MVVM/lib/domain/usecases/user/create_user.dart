import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/user/user_repository.dart';

class CreateUser implements UseCase<void, CreateUserParams> {
  final UserRepository repository;

  const CreateUser(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateUserParams params) async {
    return await repository.createUser(params.nome, params.email, params.senha);
  }
}

class CreateUserParams {
  final String nome;
  final String email;
  final String senha;

  CreateUserParams({
    required this.nome,
    required this.email,
    required this.senha,
  });
}

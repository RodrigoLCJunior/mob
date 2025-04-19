import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/user/user_repository.dart';

class LogoutUser implements UseCase<void, NoParams> {
  final UserRepository repository;

  const LogoutUser(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}

class NoParams {} // Classe vazia pra casos de uso sem parâmetros

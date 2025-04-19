import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/user/user_entity.dart';
import '../../repositories/user/user_repository.dart';

class UpdateUser implements UseCase<User, User> {
  final UserRepository repository;

  const UpdateUser(this.repository);

  @override
  Future<Either<Failure, User>> call(User user) async {
    return await repository.updateUser(user);
  }
}

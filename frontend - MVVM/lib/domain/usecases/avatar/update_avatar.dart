import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/avatar/avatar_entity.dart';
import '../../repositories/avatar/avatar_repository.dart';

class UpdateAvatar implements UseCase<Avatar, Avatar> {
  final AvatarRepository repository;

  const UpdateAvatar(this.repository);

  @override
  Future<Either<Failure, Avatar>> call(Avatar avatar) async {
    return await repository.updateAvatar(avatar);
  }
}

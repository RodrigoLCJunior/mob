import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/avatar/avatar_entity.dart';
import '../../repositories/avatar/avatar_repository.dart';

class GetAvatar implements UseCase<Avatar, String> {
  final AvatarRepository repository;

  const GetAvatar(this.repository);

  @override
  Future<Either<Failure, Avatar>> call(String avatarId) async {
    return await repository.getAvatar(avatarId);
  }
}

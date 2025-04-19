// ignore_for_file: depend_on_referenced_packages

import 'package:dartz/dartz.dart';
import 'package:midnight_never_end/domain/entities/avatar/avatar_entity.dart';
import 'package:midnight_never_end/core/error/failures.dart';

abstract class AvatarRepository {
  Future<Either<Failure, Avatar>> getAvatar(String avatarId);
  Future<Either<Failure, Avatar>> updateAvatar(Avatar avatar);
}

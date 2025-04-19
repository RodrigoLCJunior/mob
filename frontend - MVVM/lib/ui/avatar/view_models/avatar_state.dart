import '../../../domain/entities/avatar/avatar_entity.dart';

abstract class AvatarState {}

class AvatarInitial extends AvatarState {}

class AvatarLoading extends AvatarState {}

class AvatarLoaded extends AvatarState {
  final Avatar avatar;

  AvatarLoaded(this.avatar);
}

class AvatarError extends AvatarState {
  final String message;

  AvatarError(this.message);
}

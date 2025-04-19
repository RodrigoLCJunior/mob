import '../../../domain/entities/avatar/avatar_entity.dart';

abstract class AvatarEvent {}

class FetchAvatarEvent extends AvatarEvent {
  final String avatarId;

  FetchAvatarEvent(this.avatarId);
}

class UpdateAvatarEvent extends AvatarEvent {
  final Avatar avatar;

  UpdateAvatarEvent(this.avatar);
}

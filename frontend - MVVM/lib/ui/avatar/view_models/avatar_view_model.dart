import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/avatar/get_avatar.dart';
import '../../../domain/usecases/avatar/update_avatar.dart';
import 'avatar_event.dart';
import 'avatar_state.dart';

class AvatarViewModel extends Bloc<AvatarEvent, AvatarState> {
  final GetAvatar getAvatar;
  final UpdateAvatar updateAvatar;

  AvatarViewModel({required this.getAvatar, required this.updateAvatar})
    : super(AvatarInitial()) {
    on<FetchAvatarEvent>(_onFetchAvatar);
    on<UpdateAvatarEvent>(_onUpdateAvatar);
  }

  Future<void> _onFetchAvatar(
    FetchAvatarEvent event,
    Emitter<AvatarState> emit,
  ) async {
    emit(AvatarLoading());
    final result = await getAvatar(event.avatarId);
    emit(
      result.fold(
        (failure) => AvatarError(failure.message),
        (avatar) => AvatarLoaded(avatar),
      ),
    );
  }

  Future<void> _onUpdateAvatar(
    UpdateAvatarEvent event,
    Emitter<AvatarState> emit,
  ) async {
    emit(AvatarLoading());
    final result = await updateAvatar(event.avatar);
    emit(
      result.fold(
        (failure) => AvatarError(failure.message),
        (avatar) => AvatarLoaded(avatar),
      ),
    );
  }
}

/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components do avatar
 ** Obs...:
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/data/repositories/avatar/avatar_repository.dart';
import 'package:midnight_never_end/domain/entities/avatar/avatar_entity.dart';

abstract class AvatarEvent {}

class LoadAvatar extends AvatarEvent {}

class SaveAvatar extends AvatarEvent {
  final Avatar avatar;
  SaveAvatar(this.avatar);
}

class ClearAvatar extends AvatarEvent {}

class AvatarState {
  final Avatar? avatar;
  final bool isLoading;

  AvatarState({this.avatar, this.isLoading = false});

  AvatarState copyWith({Avatar? avatar, bool? isLoading}) {
    return AvatarState(
      avatar: avatar ?? this.avatar,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {
  final AvatarRepository avatarRepository;

  AvatarBloc(this.avatarRepository) : super(AvatarState()) {
    on<LoadAvatar>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final avatar = await avatarRepository.loadAvatar();
      emit(state.copyWith(avatar: avatar, isLoading: false));
    });

    on<SaveAvatar>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await avatarRepository.saveAvatar(event.avatar);
      emit(state.copyWith(avatar: event.avatar, isLoading: false));
    });

    on<ClearAvatar>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await avatarRepository.clearAvatar();
      emit(state.copyWith(avatar: null, isLoading: false));
    });
  }
}

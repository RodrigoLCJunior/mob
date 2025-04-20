/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components da progressao
 ** Obs...:
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/data/repositories/progressao/progressao_repository.dart';
import 'package:midnight_never_end/domain/entities/progressao/progressao_entity.dart';

abstract class ProgressaoEvent {}

class LoadProgressao extends ProgressaoEvent {}

class SaveProgressao extends ProgressaoEvent {
  final Progressao progressao;
  SaveProgressao(this.progressao);
}

class ClearProgressao extends ProgressaoEvent {}

class ProgressaoState {
  final Progressao? progressao;
  final bool isLoading;

  ProgressaoState({this.progressao, this.isLoading = false});

  ProgressaoState copyWith({Progressao? progressao, bool? isLoading}) {
    return ProgressaoState(
      progressao: progressao ?? this.progressao,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ProgressaoBloc extends Bloc<ProgressaoEvent, ProgressaoState> {
  final ProgressaoRepository progressaoRepository;

  ProgressaoBloc(this.progressaoRepository) : super(ProgressaoState()) {
    on<LoadProgressao>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final progressao = await progressaoRepository.loadProgressao();
      emit(state.copyWith(progressao: progressao, isLoading: false));
    });

    on<SaveProgressao>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await progressaoRepository.saveProgressao(event.progressao);
      emit(state.copyWith(progressao: event.progressao, isLoading: false));
    });

    on<ClearProgressao>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await progressaoRepository.clearProgressao();
      emit(state.copyWith(progressao: null, isLoading: false));
    });
  }
}

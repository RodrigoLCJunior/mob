import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/progressao/get_progressao.dart';
import '../../../domain/usecases/progressao/update_progressao.dart';
import 'progressao_event.dart';
import 'progressao_state.dart';

class ProgressaoViewModel extends Bloc<ProgressaoEvent, ProgressaoState> {
  final GetProgressao getProgressao;
  final UpdateProgressao updateProgressao;

  ProgressaoViewModel({
    required this.getProgressao,
    required this.updateProgressao,
  }) : super(ProgressaoInitial()) {
    on<FetchProgressaoEvent>(_onFetchProgressao);
    on<UpdateProgressaoEvent>(_onUpdateProgressao);
  }

  Future<void> _onFetchProgressao(
    FetchProgressaoEvent event,
    Emitter<ProgressaoState> emit,
  ) async {
    emit(ProgressaoLoading());
    final result = await getProgressao(event.progressaoId);
    emit(
      result.fold(
        (failure) => ProgressaoError(failure.message),
        (progressao) => ProgressaoLoaded(progressao),
      ),
    );
  }

  Future<void> _onUpdateProgressao(
    UpdateProgressaoEvent event,
    Emitter<ProgressaoState> emit,
  ) async {
    emit(ProgressaoLoading());
    final result = await updateProgressao(event.progressao);
    emit(
      result.fold(
        (failure) => ProgressaoError(failure.message),
        (progressao) => ProgressaoLoaded(progressao),
      ),
    );
  }
}

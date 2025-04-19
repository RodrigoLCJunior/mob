import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/moeda_permanente/get_moeda_permanente.dart';
import '../../../domain/usecases/moeda_permanente/update_moeda_permanente.dart';
import 'moeda_permanente_event.dart';
import 'moeda_permanente_state.dart';

class MoedaPermanenteViewModel
    extends Bloc<MoedaPermanenteEvent, MoedaPermanenteState> {
  final GetMoedaPermanente getMoedaPermanente;
  final UpdateMoedaPermanente updateMoedaPermanente;

  MoedaPermanenteViewModel({
    required this.getMoedaPermanente,
    required this.updateMoedaPermanente,
  }) : super(MoedaPermanenteInitial()) {
    on<FetchMoedaPermanenteEvent>(_onFetchMoedaPermanente);
    on<UpdateMoedaPermanenteEvent>(_onUpdateMoedaPermanente);
  }

  Future<void> _onFetchMoedaPermanente(
    FetchMoedaPermanenteEvent event,
    Emitter<MoedaPermanenteState> emit,
  ) async {
    emit(MoedaPermanenteLoading());
    final result = await getMoedaPermanente(event.userId);
    emit(
      result.fold(
        (failure) => MoedaPermanenteError(failure.message),
        (moeda) => MoedaPermanenteLoaded(moeda),
      ),
    );
  }

  Future<void> _onUpdateMoedaPermanente(
    UpdateMoedaPermanenteEvent event,
    Emitter<MoedaPermanenteState> emit,
  ) async {
    emit(MoedaPermanenteLoading());
    final result = await updateMoedaPermanente(event.moeda);
    emit(
      result.fold(
        (failure) => MoedaPermanenteError(failure.message),
        (moeda) => MoedaPermanenteLoaded(moeda),
      ),
    );
  }
}

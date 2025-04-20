/*
 ** Task..: 53 - 52 - MVVM e BLoC - frontend
 ** Data..: 20/04/2025
 ** Autor.: Rodrigo Luiz
 ** Motivo: Business Logic Object Components da moeda permenente
 ** Obs...:
 */

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:midnight_never_end/data/repositories/moeda_permanente/moeda_permanente_repository.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';

abstract class MoedaPermanenteEvent {}

class LoadMoeda extends MoedaPermanenteEvent {}

class SaveMoeda extends MoedaPermanenteEvent {
  final MoedaPermanente moeda;
  SaveMoeda(this.moeda);
}

class ClearMoeda extends MoedaPermanenteEvent {}

class MoedaPermanenteState {
  final MoedaPermanente? moeda;
  final bool isLoading;

  MoedaPermanenteState({this.moeda, this.isLoading = false});

  MoedaPermanenteState copyWith({MoedaPermanente? moeda, bool? isLoading}) {
    return MoedaPermanenteState(
      moeda: moeda ?? this.moeda,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class MoedaPermanenteBloc
    extends Bloc<MoedaPermanenteEvent, MoedaPermanenteState> {
  final MoedaPermanenteRepository moedaRepository;

  MoedaPermanenteBloc(this.moedaRepository) : super(MoedaPermanenteState()) {
    on<LoadMoeda>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final moeda = await moedaRepository.loadMoeda();
      emit(state.copyWith(moeda: moeda, isLoading: false));
    });

    on<SaveMoeda>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await moedaRepository.saveMoeda(event.moeda);
      emit(state.copyWith(moeda: event.moeda, isLoading: false));
    });

    on<ClearMoeda>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      await moedaRepository.clearMoeda();
      emit(state.copyWith(moeda: null, isLoading: false));
    });
  }
}

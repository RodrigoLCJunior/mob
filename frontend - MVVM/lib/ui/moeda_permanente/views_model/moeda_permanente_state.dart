import '../../../domain/entities/moeda_permanente/moeda_permanente_entity.dart';

abstract class MoedaPermanenteState {}

class MoedaPermanenteInitial extends MoedaPermanenteState {}

class MoedaPermanenteLoading extends MoedaPermanenteState {}

class MoedaPermanenteLoaded extends MoedaPermanenteState {
  final MoedaPermanente moeda;

  MoedaPermanenteLoaded(this.moeda);
}

class MoedaPermanenteError extends MoedaPermanenteState {
  final String message;

  MoedaPermanenteError(this.message);
}

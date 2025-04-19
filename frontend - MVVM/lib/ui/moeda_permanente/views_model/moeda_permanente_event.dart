import '../../../domain/entities/moeda_permanente/moeda_permanente_entity.dart';

abstract class MoedaPermanenteEvent {}

class FetchMoedaPermanenteEvent extends MoedaPermanenteEvent {
  final String userId;

  FetchMoedaPermanenteEvent(this.userId);
}

class UpdateMoedaPermanenteEvent extends MoedaPermanenteEvent {
  final MoedaPermanente moeda;

  UpdateMoedaPermanenteEvent(this.moeda);
}

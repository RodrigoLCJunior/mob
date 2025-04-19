import '../../../domain/entities/progressao/progressao_entity.dart';

abstract class ProgressaoEvent {}

class FetchProgressaoEvent extends ProgressaoEvent {
  final String progressaoId;

  FetchProgressaoEvent(this.progressaoId);
}

class UpdateProgressaoEvent extends ProgressaoEvent {
  final Progressao progressao;

  UpdateProgressaoEvent(this.progressao);
}

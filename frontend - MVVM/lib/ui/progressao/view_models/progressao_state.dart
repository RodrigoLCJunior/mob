import '../../../domain/entities/progressao/progressao_entity.dart';

abstract class ProgressaoState {}

class ProgressaoInitial extends ProgressaoState {}

class ProgressaoLoading extends ProgressaoState {}

class ProgressaoLoaded extends ProgressaoState {
  final Progressao progressao;

  ProgressaoLoaded(this.progressao);
}

class ProgressaoError extends ProgressaoState {
  final String message;

  ProgressaoError(this.message);
}

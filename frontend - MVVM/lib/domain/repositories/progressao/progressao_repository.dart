import 'package:dartz/dartz.dart';
import 'package:midnight_never_end/domain/entities/progressao/progressao_entity.dart';
import 'package:midnight_never_end/core/error/failures.dart';

abstract class ProgressaoRepository {
  Future<Either<Failure, Progressao>> getProgressao(String progressaoId);
  Future<Either<Failure, Progressao>> updateProgressao(Progressao progressao);
}

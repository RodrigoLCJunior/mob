import 'package:dartz/dartz.dart';
import 'package:midnight_never_end/domain/entities/moeda_permanente/moeda_permanente_entity.dart';
import 'package:midnight_never_end/core/error/failures.dart';

abstract class MoedaPermanenteRepository {
  Future<Either<Failure, MoedaPermanente>> getMoedaPermanente(String userId);
  Future<Either<Failure, MoedaPermanente>> updateMoedaPermanente(
    MoedaPermanente moeda,
  );
}

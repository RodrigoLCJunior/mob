import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/moeda_permanente/moeda_permanente_entity.dart';
import '../../repositories/moeda_permanente/moeda_permanente_repository.dart';

class UpdateMoedaPermanente
    implements UseCase<MoedaPermanente, MoedaPermanente> {
  final MoedaPermanenteRepository repository;

  const UpdateMoedaPermanente(this.repository);

  @override
  Future<Either<Failure, MoedaPermanente>> call(MoedaPermanente moeda) async {
    return await repository.updateMoedaPermanente(moeda);
  }
}

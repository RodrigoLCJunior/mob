import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/moeda_permanente/moeda_permanente_entity.dart';
import '../../repositories/moeda_permanente/moeda_permanente_repository.dart';

class GetMoedaPermanente implements UseCase<MoedaPermanente, String> {
  final MoedaPermanenteRepository repository;

  const GetMoedaPermanente(this.repository);

  @override
  Future<Either<Failure, MoedaPermanente>> call(String userId) async {
    return await repository.getMoedaPermanente(userId);
  }
}

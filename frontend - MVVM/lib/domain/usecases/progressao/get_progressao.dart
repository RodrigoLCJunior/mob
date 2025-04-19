import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/progressao/progressao_entity.dart';
import '../../repositories/progressao/progressao_repository.dart';

class GetProgressao implements UseCase<Progressao, String> {
  final ProgressaoRepository repository;

  const GetProgressao(this.repository);

  @override
  Future<Either<Failure, Progressao>> call(String progressaoId) async {
    return await repository.getProgressao(progressaoId);
  }
}

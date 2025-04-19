import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/progressao/progressao_entity.dart';
import '../../repositories/progressao/progressao_repository.dart';

class UpdateProgressao implements UseCase<Progressao, Progressao> {
  final ProgressaoRepository repository;

  const UpdateProgressao(this.repository);

  @override
  Future<Either<Failure, Progressao>> call(Progressao progressao) async {
    return await repository.updateProgressao(progressao);
  }
}

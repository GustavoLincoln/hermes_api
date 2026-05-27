import '../entities/environment_entity.dart';
import '../repositories/environment_repository.dart';

class GetEnvironmentsUsecase {
  const GetEnvironmentsUsecase(this._repository);

  final EnvironmentRepository _repository;

  Future<List<EnvironmentEntity>> call() {
    return _repository.getEnvironments();
  }
}

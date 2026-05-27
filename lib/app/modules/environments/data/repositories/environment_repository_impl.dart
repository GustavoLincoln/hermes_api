import '../../domain/entities/environment_entity.dart';
import '../../domain/repositories/environment_repository.dart';

class EnvironmentRepositoryImpl implements EnvironmentRepository {
  const EnvironmentRepositoryImpl();

  @override
  Future<List<EnvironmentEntity>> getEnvironments() async {
    return const <EnvironmentEntity>[];
  }
}

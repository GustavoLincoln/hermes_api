import '../entities/environment_entity.dart';

abstract class EnvironmentRepository {
  Future<List<EnvironmentEntity>> getEnvironments();
}

import '../entities/api_request_entity.dart';
import '../repositories/request_repository.dart';

class SaveRequestUsecase {
  const SaveRequestUsecase(this._repository);

  final RequestRepository _repository;

  Future<void> call(ApiRequestEntity request) {
    return _repository.save(request);
  }
}

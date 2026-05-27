import '../entities/api_request_entity.dart';
import '../entities/api_response_entity.dart';
import '../repositories/request_repository.dart';

class ExecuteRequestUsecase {
  const ExecuteRequestUsecase(this._repository);

  final RequestRepository _repository;

  Future<ApiResponseEntity> call(ApiRequestEntity request) {
    return _repository.execute(request);
  }
}

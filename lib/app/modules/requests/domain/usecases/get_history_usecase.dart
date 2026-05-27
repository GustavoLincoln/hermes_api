import '../entities/api_request_entity.dart';
import '../repositories/request_repository.dart';

class GetHistoryUsecase {
  const GetHistoryUsecase(this._repository);

  final RequestRepository _repository;

  Future<List<ApiRequestEntity>> call() {
    return _repository.getHistory();
  }
}

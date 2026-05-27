import '../entities/api_request_entity.dart';
import '../entities/api_response_entity.dart';

abstract class RequestRepository {
  Future<ApiResponseEntity> execute(ApiRequestEntity request);
  Future<void> save(ApiRequestEntity request);
  Future<List<ApiRequestEntity>> getHistory();
}

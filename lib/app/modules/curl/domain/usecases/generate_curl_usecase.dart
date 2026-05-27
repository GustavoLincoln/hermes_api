import '../../../requests/domain/entities/api_request_entity.dart';
import '../repositories/curl_repository.dart';

class GenerateCurlUsecase {
  const GenerateCurlUsecase(this._repository);

  final CurlRepository _repository;

  String call(ApiRequestEntity request) {
    return _repository.generate(request);
  }
}

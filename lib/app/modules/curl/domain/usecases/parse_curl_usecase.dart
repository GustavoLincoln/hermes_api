import '../../../requests/domain/entities/api_request_entity.dart';
import '../repositories/curl_repository.dart';

class ParseCurlUsecase {
  const ParseCurlUsecase(this._repository);

  final CurlRepository _repository;

  ApiRequestEntity call(String command) {
    return _repository.parse(command);
  }
}

import '../../../requests/domain/entities/api_request_entity.dart';

abstract class CurlRepository {
  ApiRequestEntity parse(String command);
  String generate(ApiRequestEntity request);
}

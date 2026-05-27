import '../../domain/entities/api_response_entity.dart';

class ApiResponseModel extends ApiResponseEntity {
  const ApiResponseModel({
    required super.body,
    required super.headers,
    required super.duration,
    super.statusCode,
    super.statusMessage,
    super.requestUrl,
  });
}

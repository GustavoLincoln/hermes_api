import 'package:dio/dio.dart';

import '../../../../shared/entities/key_value_entry.dart';
import '../models/api_request_model.dart';
import '../models/api_response_model.dart';

class RequestRemoteDataSource {
  const RequestRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ApiResponseModel> execute(ApiRequestModel request) async {
    final stopwatch = Stopwatch()..start();

    try {
      final response = await _dio.request<String>(
        request.url,
        data: request.body.trim().isEmpty ? null : request.body,
        queryParameters: _toMap(request.queryParams),
        options: Options(
          method: request.method.label,
          headers: _toMap(request.headers),
        ),
      );

      stopwatch.stop();
      return ApiResponseModel(
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
        body: response.data ?? '',
        headers: _flattenHeaders(response.headers.map),
        duration: stopwatch.elapsed,
        requestUrl: response.realUri.toString(),
      );
    } on DioException catch (error) {
      stopwatch.stop();
      final response = error.response;
      return ApiResponseModel(
        statusCode: response?.statusCode,
        statusMessage: error.message,
        body: response?.data?.toString() ?? error.message ?? 'Request failed.',
        headers: response != null ? _flattenHeaders(response.headers.map) : <String, String>{},
        duration: stopwatch.elapsed,
        requestUrl: response?.realUri.toString() ?? request.url,
      );
    }
  }

  Map<String, String> _toMap(List<KeyValueEntry> entries) {
    return <String, String>{
      for (final entry in entries)
        if (entry.enabled && entry.key.trim().isNotEmpty) entry.key.trim(): entry.value.trim(),
    };
  }

  Map<String, String> _flattenHeaders(Map<String, List<String>> headers) {
    return <String, String>{
      for (final MapEntry<String, List<String>> entry in headers.entries)
        entry.key: entry.value.join(', '),
    };
  }
}

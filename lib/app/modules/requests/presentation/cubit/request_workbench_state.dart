import 'package:equatable/equatable.dart';

import '../../../../shared/entities/key_value_entry.dart';
import '../../domain/entities/api_request_entity.dart';
import '../../domain/entities/api_response_entity.dart';
import '../../domain/enums/http_method_enum.dart';

class RequestWorkbenchState extends Equatable {
  const RequestWorkbenchState({
    this.method = HttpMethodEnum.get,
    this.url = '',
    this.headersText = '',
    this.queryParamsText = '',
    this.body = '',
    this.curlInput = '',
    this.generatedCurl = '',
    this.response,
    this.history = const <ApiRequestEntity>[],
    this.isLoading = false,
    this.errorMessage,
  });

  final HttpMethodEnum method;
  final String url;
  final String headersText;
  final String queryParamsText;
  final String body;
  final String curlInput;
  final String generatedCurl;
  final ApiResponseEntity? response;
  final List<ApiRequestEntity> history;
  final bool isLoading;
  final String? errorMessage;

  ApiRequestEntity toEntity() {
    return ApiRequestEntity(
      method: method,
      url: url,
      headers: _parseHeaders(headersText),
      queryParams: _parseQueryParams(queryParamsText),
      body: body,
      createdAt: DateTime.now(),
    );
  }

  RequestWorkbenchState copyWith({
    HttpMethodEnum? method,
    String? url,
    String? headersText,
    String? queryParamsText,
    String? body,
    String? curlInput,
    String? generatedCurl,
    ApiResponseEntity? response,
    List<ApiRequestEntity>? history,
    bool? isLoading,
    String? errorMessage,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return RequestWorkbenchState(
      method: method ?? this.method,
      url: url ?? this.url,
      headersText: headersText ?? this.headersText,
      queryParamsText: queryParamsText ?? this.queryParamsText,
      body: body ?? this.body,
      curlInput: curlInput ?? this.curlInput,
      generatedCurl: generatedCurl ?? this.generatedCurl,
      response: clearResponse ? null : response ?? this.response,
      history: history ?? this.history,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  static List<KeyValueEntry> _parseHeaders(String input) {
    final lines = input.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty);
    return lines.map((line) {
      final separator = line.indexOf(':');
      if (separator == -1) {
        return KeyValueEntry(key: line, value: '');
      }
      return KeyValueEntry(
        key: line.substring(0, separator).trim(),
        value: line.substring(separator + 1).trim(),
      );
    }).toList();
  }

  static List<KeyValueEntry> _parseQueryParams(String input) {
    final lines = input.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty);
    return lines.map((line) {
      final separator = line.indexOf('=');
      if (separator == -1) {
        return KeyValueEntry(key: line, value: '');
      }
      return KeyValueEntry(
        key: line.substring(0, separator).trim(),
        value: line.substring(separator + 1).trim(),
      );
    }).toList();
  }

  static String headersToText(List<KeyValueEntry> entries) {
    return entries.map((entry) => '${entry.key}: ${entry.value}').join('\n');
  }

  static String queryParamsToText(List<KeyValueEntry> entries) {
    return entries.map((entry) => '${entry.key}=${entry.value}').join('\n');
  }

  @override
  List<Object?> get props => <Object?>[
        method,
        url,
        headersText,
        queryParamsText,
        body,
        curlInput,
        generatedCurl,
        response,
        history,
        isLoading,
        errorMessage,
      ];
}

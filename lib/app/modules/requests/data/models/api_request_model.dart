import '../../../../shared/entities/key_value_entry.dart';
import '../../domain/entities/api_request_entity.dart';
import '../../domain/enums/http_method_enum.dart';

class ApiRequestModel extends ApiRequestEntity {
  const ApiRequestModel({
    required super.method,
    required super.url,
    super.headers,
    super.queryParams,
    super.body,
    super.name,
    super.createdAt,
  });

  factory ApiRequestModel.fromEntity(ApiRequestEntity entity) {
    return ApiRequestModel(
      method: entity.method,
      url: entity.url,
      headers: entity.headers,
      queryParams: entity.queryParams,
      body: entity.body,
      name: entity.name,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'method': method.label,
      'url': url,
      'headers': headers.map((entry) => entry.toJson()).toList(),
      'queryParams': queryParams.map((entry) => entry.toJson()).toList(),
      'body': body,
      'name': name,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  factory ApiRequestModel.fromJson(Map<dynamic, dynamic> json) {
    return ApiRequestModel(
      method: HttpMethodEnum.fromString(json['method'] as String? ?? 'GET'),
      url: json['url'] as String? ?? '',
      headers: ((json['headers'] as List<dynamic>? ?? <dynamic>[]))
          .map((dynamic item) => KeyValueEntry.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      queryParams: ((json['queryParams'] as List<dynamic>? ?? <dynamic>[]))
          .map((dynamic item) => KeyValueEntry.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList(),
      body: json['body'] as String? ?? '',
      name: json['name'] as String?,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }
}

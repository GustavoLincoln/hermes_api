import 'package:equatable/equatable.dart';

import '../../../../shared/entities/key_value_entry.dart';
import '../enums/http_method_enum.dart';

class ApiRequestEntity extends Equatable {
  const ApiRequestEntity({
    required this.method,
    required this.url,
    this.headers = const <KeyValueEntry>[],
    this.queryParams = const <KeyValueEntry>[],
    this.body = '',
    this.name,
    this.createdAt,
  });

  final HttpMethodEnum method;
  final String url;
  final List<KeyValueEntry> headers;
  final List<KeyValueEntry> queryParams;
  final String body;
  final String? name;
  final DateTime? createdAt;

  Uri? get uri => Uri.tryParse(url);

  ApiRequestEntity copyWith({
    HttpMethodEnum? method,
    String? url,
    List<KeyValueEntry>? headers,
    List<KeyValueEntry>? queryParams,
    String? body,
    String? name,
    DateTime? createdAt,
  }) {
    return ApiRequestEntity(
      method: method ?? this.method,
      url: url ?? this.url,
      headers: headers ?? this.headers,
      queryParams: queryParams ?? this.queryParams,
      body: body ?? this.body,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        method,
        url,
        headers,
        queryParams,
        body,
        name,
        createdAt,
      ];
}

import 'package:equatable/equatable.dart';

class ApiResponseEntity extends Equatable {
  const ApiResponseEntity({
    required this.body,
    required this.headers,
    required this.duration,
    this.statusCode,
    this.statusMessage,
    this.requestUrl,
  });

  final int? statusCode;
  final String body;
  final Map<String, String> headers;
  final Duration duration;
  final String? statusMessage;
  final String? requestUrl;

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 400;

  @override
  List<Object?> get props => <Object?>[
        statusCode,
        body,
        headers,
        duration,
        statusMessage,
        requestUrl,
      ];
}

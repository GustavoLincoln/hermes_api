import 'package:dio/dio.dart';

class DioFactory {
  const DioFactory();

  Dio create() {
    return Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        validateStatus: (_) => true,
        responseType: ResponseType.plain,
      ),
    );
  }
}

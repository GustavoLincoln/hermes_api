import 'package:fluent_ui/fluent_ui.dart';

enum HttpMethodEnum {
  get('GET', Color(0xFF4CAF50)),
  post('POST', Color(0xFFFFD700)),
  put('PUT', Color(0XFF64B5F6)),
  patch('PATCH', Color(0XFFBA68C8)),
  delete('DELETE', Color(0XFFEF5350));

  const HttpMethodEnum(this.label, this.color);

  final String label;
  final Color color;

  static HttpMethodEnum fromString(String value) {
    return HttpMethodEnum.values.firstWhere(
      (method) => method.label.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => HttpMethodEnum.get,
    );
  }
}

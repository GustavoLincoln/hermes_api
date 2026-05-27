import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_api/app/modules/curl/data/datasources/curl_local_datasource.dart';
import 'package:hermes_api/app/modules/requests/domain/enums/http_method_enum.dart';

void main() {
  group('CurlLocalDataSource', () {
    final datasource = CurlLocalDataSource();

    test('parses method, url, headers and body from curl', () {
      final request = datasource.parse(
        "curl -X POST 'https://api.example.com/users?page=1' "
        "-H 'Content-Type: application/json' "
        "--data-raw '{\"name\":\"Hermes\"}'",
      );

      expect(request.method, HttpMethodEnum.post);
      expect(request.url, 'https://api.example.com/users');
      expect(request.queryParams.first.key, 'page');
      expect(request.queryParams.first.value, '1');
      expect(request.headers.first.key, 'Content-Type');
      expect(request.body, '{"name":"Hermes"}');
    });

    test('generates curl from request entity', () {
      final request = datasource.parse(
        "curl -X DELETE 'https://api.example.com/users/42' -H 'Accept: application/json'",
      );

      final generated = datasource.generate(request);

      expect(generated, contains('curl -X DELETE'));
      expect(generated, contains('https://api.example.com/users/42'));
      expect(generated, contains("Accept: application/json"));
    });
  });
}

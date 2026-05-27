import '../../../../shared/entities/key_value_entry.dart';
import '../../../requests/domain/entities/api_request_entity.dart';
import '../../../requests/domain/enums/http_method_enum.dart';

class CurlLocalDataSource {
  ApiRequestEntity parse(String command) {
    final tokens = _tokenize(command);

    var method = HttpMethodEnum.get;
    String url = '';
    String body = '';
    final headers = <KeyValueEntry>[];

    for (var index = 0; index < tokens.length; index++) {
      final token = tokens[index];
      final next = index + 1 < tokens.length ? tokens[index + 1] : null;

      if (token == 'curl') {
        continue;
      }

      if (token == '-X' || token == '--request') {
        if (next != null) {
          method = HttpMethodEnum.fromString(next);
          index++;
        }
        continue;
      }

      if (token == '-H' || token == '--header') {
        if (next != null) {
          headers.add(_parseHeader(next));
          index++;
        }
        continue;
      }

      if (token == '-d' || token == '--data' || token == '--data-raw') {
        if (next != null) {
          body = _stripQuotes(next);
          if (method == HttpMethodEnum.get) {
            method = HttpMethodEnum.post;
          }
          index++;
        }
        continue;
      }

      if (token == '--url') {
        if (next != null) {
          url = _stripQuotes(next);
          index++;
        }
        continue;
      }

      if (!token.startsWith('-') && url.isEmpty) {
        url = _stripQuotes(token);
      }
    }

    final parsedUri = Uri.tryParse(url);
    final queryParams = <KeyValueEntry>[
      if (parsedUri != null)
        ...parsedUri.queryParametersAll.entries.map(
          (entry) => KeyValueEntry(
            key: entry.key,
            value: entry.value.join(','),
          ),
        ),
    ];

    final sanitizedUrl = parsedUri != null && parsedUri.hasQuery
        ? parsedUri.replace(query: '').toString()
        : url;

    return ApiRequestEntity(
      method: method,
      url: sanitizedUrl,
      headers: headers,
      queryParams: queryParams,
      body: body,
      createdAt: DateTime.now(),
    );
  }

  String generate(ApiRequestEntity request) {
    final buffer = StringBuffer('curl -X ${request.method.label}');
    final url = _withQueryParams(request);

    buffer.write(" '$url'");

    for (final header in request.headers.where((entry) => entry.enabled && entry.key.trim().isNotEmpty)) {
      buffer.write(" -H '${_escape(header.key)}: ${_escape(header.value)}'");
    }

    if (request.body.trim().isNotEmpty) {
      buffer.write(" --data-raw '${_escape(request.body)}'");
    }

    return buffer.toString();
  }

  List<String> _tokenize(String command) {
    final tokens = <String>[];
    final buffer = StringBuffer();
    String? activeQuote;

    for (final rune in command.runes) {
      final character = String.fromCharCode(rune);

      if (activeQuote == null && (character == '"' || character == "'")) {
        activeQuote = character;
        buffer.write(character);
        continue;
      }

      if (activeQuote != null && character == activeQuote) {
        buffer.write(character);
        activeQuote = null;
        continue;
      }

      if (activeQuote == null && character.trim().isEmpty) {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        continue;
      }

      buffer.write(character);
    }

    if (buffer.isNotEmpty) {
      tokens.add(buffer.toString());
    }

    return tokens;
  }

  KeyValueEntry _parseHeader(String rawHeader) {
    final value = _stripQuotes(rawHeader);
    final separatorIndex = value.indexOf(':');
    if (separatorIndex == -1) {
      return KeyValueEntry(key: value, value: '');
    }

    return KeyValueEntry(
      key: value.substring(0, separatorIndex).trim(),
      value: value.substring(separatorIndex + 1).trim(),
    );
  }

  String _stripQuotes(String value) {
    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      return value.substring(1, value.length - 1);
    }
    return value;
  }

  String _withQueryParams(ApiRequestEntity request) {
    final baseUri = Uri.tryParse(request.url);
    if (baseUri == null || request.queryParams.isEmpty) {
      return request.url;
    }

    final queryParameters = <String, String>{
      ...baseUri.queryParameters,
      for (final entry in request.queryParams)
        if (entry.enabled && entry.key.trim().isNotEmpty) entry.key.trim(): entry.value.trim(),
    };

    return baseUri.replace(queryParameters: queryParameters).toString();
  }

  String _escape(String value) {
    return value.replaceAll("'", r"'\''");
  }
}

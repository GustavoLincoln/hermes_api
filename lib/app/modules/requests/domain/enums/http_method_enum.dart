enum HttpMethodEnum {
  get('GET'),
  post('POST'),
  put('PUT'),
  patch('PATCH'),
  delete('DELETE');

  const HttpMethodEnum(this.label);

  final String label;

  static HttpMethodEnum fromString(String value) {
    return HttpMethodEnum.values.firstWhere(
      (method) => method.label.toLowerCase() == value.trim().toLowerCase(),
      orElse: () => HttpMethodEnum.get,
    );
  }
}

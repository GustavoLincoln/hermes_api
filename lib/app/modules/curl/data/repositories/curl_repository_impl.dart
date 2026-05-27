import '../../../requests/domain/entities/api_request_entity.dart';
import '../../domain/repositories/curl_repository.dart';
import '../datasources/curl_local_datasource.dart';

class CurlRepositoryImpl implements CurlRepository {
  const CurlRepositoryImpl(this._dataSource);

  final CurlLocalDataSource _dataSource;

  @override
  String generate(ApiRequestEntity request) {
    return _dataSource.generate(request);
  }

  @override
  ApiRequestEntity parse(String command) {
    return _dataSource.parse(command);
  }
}

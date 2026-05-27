import '../../domain/entities/api_request_entity.dart';
import '../../domain/entities/api_response_entity.dart';
import '../../domain/repositories/request_repository.dart';
import '../datasources/request_local_datasource.dart';
import '../datasources/request_remote_datasource.dart';
import '../models/api_request_model.dart';

class RequestRepositoryImpl implements RequestRepository {
  const RequestRepositoryImpl({
    required RequestLocalDataSource localDataSource,
    required RequestRemoteDataSource remoteDataSource,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource;

  final RequestLocalDataSource _localDataSource;
  final RequestRemoteDataSource _remoteDataSource;

  @override
  Future<ApiResponseEntity> execute(ApiRequestEntity request) {
    return _remoteDataSource.execute(ApiRequestModel.fromEntity(request));
  }

  @override
  Future<List<ApiRequestEntity>> getHistory() {
    return _localDataSource.getHistory();
  }

  @override
  Future<void> save(ApiRequestEntity request) {
    return _localDataSource.saveRequest(
      ApiRequestModel.fromEntity(
        request.copyWith(createdAt: request.createdAt ?? DateTime.now()),
      ),
    );
  }
}

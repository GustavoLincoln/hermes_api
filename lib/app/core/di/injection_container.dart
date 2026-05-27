import 'package:get_it/get_it.dart';

import '../../modules/curl/data/datasources/curl_local_datasource.dart';
import '../../modules/curl/data/repositories/curl_repository_impl.dart';
import '../../modules/curl/domain/repositories/curl_repository.dart';
import '../../modules/curl/domain/usecases/generate_curl_usecase.dart';
import '../../modules/curl/domain/usecases/parse_curl_usecase.dart';
import '../../modules/requests/data/datasources/request_local_datasource.dart';
import '../../modules/requests/data/datasources/request_remote_datasource.dart';
import '../../modules/requests/data/repositories/request_repository_impl.dart';
import '../../modules/requests/domain/repositories/request_repository.dart';
import '../../modules/requests/domain/usecases/execute_request_usecase.dart';
import '../../modules/requests/domain/usecases/get_history_usecase.dart';
import '../../modules/requests/domain/usecases/save_request_usecase.dart';
import '../../modules/requests/presentation/cubit/request_workbench_cubit.dart';
import '../constants/app_constants.dart';
import '../http/dio_factory.dart';
import '../storage/hive_storage_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  getIt.registerSingleton<HiveStorageService>(const HiveStorageService());
  await getIt<HiveStorageService>().initialize();

  final historyBox = await getIt<HiveStorageService>().openBox(AppConstants.historyBox);

  getIt
    ..registerLazySingleton<DioFactory>(() => const DioFactory())
    ..registerLazySingleton(() => getIt<DioFactory>().create())
    ..registerLazySingleton(() => RequestLocalDataSource(historyBox))
    ..registerLazySingleton(() => RequestRemoteDataSource(getIt()))
    ..registerLazySingleton<RequestRepository>(
      () => RequestRepositoryImpl(
        localDataSource: getIt(),
        remoteDataSource: getIt(),
      ),
    )
    ..registerLazySingleton(() => CurlLocalDataSource())
    ..registerLazySingleton<CurlRepository>(() => CurlRepositoryImpl(getIt()))
    ..registerLazySingleton(() => ExecuteRequestUsecase(getIt()))
    ..registerLazySingleton(() => SaveRequestUsecase(getIt()))
    ..registerLazySingleton(() => GetHistoryUsecase(getIt()))
    ..registerLazySingleton(() => ParseCurlUsecase(getIt()))
    ..registerLazySingleton(() => GenerateCurlUsecase(getIt()))
    ..registerFactory(
      () => RequestWorkbenchCubit(
        executeRequest: getIt(),
        saveRequest: getIt(),
        getHistory: getIt(),
        parseCurl: getIt(),
        generateCurl: getIt(),
      ),
    );
}

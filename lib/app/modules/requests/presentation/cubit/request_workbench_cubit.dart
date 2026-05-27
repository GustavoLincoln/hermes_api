import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../curl/domain/usecases/generate_curl_usecase.dart';
import '../../../curl/domain/usecases/parse_curl_usecase.dart';
import '../../domain/entities/api_request_entity.dart';
import '../../domain/enums/http_method_enum.dart';
import '../../domain/usecases/execute_request_usecase.dart';
import '../../domain/usecases/get_history_usecase.dart';
import '../../domain/usecases/save_request_usecase.dart';
import 'request_workbench_state.dart';

class RequestWorkbenchCubit extends Cubit<RequestWorkbenchState> {
  RequestWorkbenchCubit({
    required ExecuteRequestUsecase executeRequest,
    required SaveRequestUsecase saveRequest,
    required GetHistoryUsecase getHistory,
    required ParseCurlUsecase parseCurl,
    required GenerateCurlUsecase generateCurl,
  })  : _executeRequest = executeRequest,
        _saveRequest = saveRequest,
        _getHistory = getHistory,
        _parseCurl = parseCurl,
        _generateCurl = generateCurl,
        super(const RequestWorkbenchState());

  final ExecuteRequestUsecase _executeRequest;
  final SaveRequestUsecase _saveRequest;
  final GetHistoryUsecase _getHistory;
  final ParseCurlUsecase _parseCurl;
  final GenerateCurlUsecase _generateCurl;

  Future<void> initialize() async {
    final history = await _getHistory();
    emit(state.copyWith(history: history, clearError: true));
  }

  void updateMethod(HttpMethodEnum method) => emit(state.copyWith(method: method));
  void updateUrl(String value) => emit(state.copyWith(url: value));
  void updateHeaders(String value) => emit(state.copyWith(headersText: value));
  void updateQueryParams(String value) => emit(state.copyWith(queryParamsText: value));
  void updateBody(String value) => emit(state.copyWith(body: value));
  void updateCurlInput(String value) => emit(state.copyWith(curlInput: value));

  Future<void> execute() async {
    final request = state.toEntity();
    if (request.url.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Informe uma URL para executar a requisição.'));
      return;
    }

    emit(state.copyWith(isLoading: true, clearError: true));

    final response = await _executeRequest(request);
    await _saveRequest(request);
    final history = await _getHistory();
    final generatedCurl = _generateCurl(request);

    emit(
      state.copyWith(
        response: response,
        history: history,
        generatedCurl: generatedCurl,
        isLoading: false,
      ),
    );
  }

  void importCurl() {
    if (state.curlInput.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Cole um comando cURL para importar.'));
      return;
    }

    final request = _parseCurl(state.curlInput);
    _hydrateFromRequest(request);
  }

  void loadFromHistory(ApiRequestEntity request) {
    _hydrateFromRequest(request);
  }

  void refreshGeneratedCurl() {
    emit(state.copyWith(generatedCurl: _generateCurl(state.toEntity())));
  }

  void _hydrateFromRequest(ApiRequestEntity request) {
    emit(
      state.copyWith(
        method: request.method,
        url: request.url,
        headersText: RequestWorkbenchState.headersToText(request.headers),
        queryParamsText: RequestWorkbenchState.queryParamsToText(request.queryParams),
        body: request.body,
        generatedCurl: _generateCurl(request),
        clearError: true,
      ),
    );
  }
}

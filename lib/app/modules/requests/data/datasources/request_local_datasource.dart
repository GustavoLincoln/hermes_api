import 'package:hive/hive.dart';

import '../../../../core/constants/app_constants.dart';
import '../models/api_request_model.dart';

class RequestLocalDataSource {
  const RequestLocalDataSource(this._historyBox);

  final Box<dynamic> _historyBox;

  Future<void> saveRequest(ApiRequestModel request) async {
    await _historyBox.add(request.toJson());

    while (_historyBox.length > AppConstants.historyLimit) {
      await _historyBox.deleteAt(0);
    }
  }

  Future<List<ApiRequestModel>> getHistory() async {
    return _historyBox.values
        .map((dynamic raw) => ApiRequestModel.fromJson(Map<dynamic, dynamic>.from(raw as Map)))
        .toList()
        .reversed
        .toList();
  }
}

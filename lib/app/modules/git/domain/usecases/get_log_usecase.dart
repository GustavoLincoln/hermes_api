import 'package:injectable/injectable.dart';

import '../entities/git_commit.dart';
import '../repositories/i_git_repository.dart';

@lazySingleton
class GetLogUseCase {
  final IGitRepository _repository;

  const GetLogUseCase(this._repository);

  Future<List<GitCommit>> call(String repoPath, {int limit = 50}) =>
      _repository.log(repoPath, limit: limit);
}

import 'package:injectable/injectable.dart';

import '../entities/git_status.dart';
import '../repositories/i_git_repository.dart';

@lazySingleton
class GetGitStatusUseCase {
  final IGitRepository _repository;

  const GetGitStatusUseCase(this._repository);

  Future<GitStatus> call(String repoPath) => _repository.status(repoPath);
}

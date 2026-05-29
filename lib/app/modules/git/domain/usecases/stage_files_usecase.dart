import 'package:injectable/injectable.dart';

import '../repositories/i_git_repository.dart';

@lazySingleton
class StageFilesUseCase {
  final IGitRepository _repository;

  const StageFilesUseCase(this._repository);

  Future<void> stageFile(String repoPath, String filePath) =>
      _repository.add(repoPath, filePath: filePath);

  Future<void> stageAll(String repoPath) => _repository.add(repoPath);

  Future<void> unstageFile(String repoPath, String filePath) =>
      _repository.unstage(repoPath, filePath);

  Future<void> discardFile(String repoPath, String filePath) =>
      _repository.discard(repoPath, filePath);
}

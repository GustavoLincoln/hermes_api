import 'package:injectable/injectable.dart';

import '../entities/git_commit.dart';
import '../entities/git_exceptions.dart';
import '../repositories/i_git_repository.dart';

@lazySingleton
class CommitUseCase {
  final IGitRepository _repository;

  const CommitUseCase(this._repository);

  Future<GitCommit> call(String repoPath, String message) async {
    if (message.trim().isEmpty) {
      throw const GitException(
        message: 'A mensagem do commit não pode estar vazia.',
      );
    }
    return _repository.commit(repoPath, message.trim());
  }
}

import 'package:injectable/injectable.dart';

import '../entities/git_branch.dart';
import '../repositories/i_git_repository.dart';

@lazySingleton
class BranchUseCase {
  final IGitRepository _repository;

  const BranchUseCase(this._repository);

  Future<List<GitBranch>> listBranches(String repoPath) =>
      _repository.branches(repoPath);

  Future<void> createBranch(String repoPath, String name) =>
      _repository.createBranch(repoPath, name);

  Future<void> checkout(String repoPath, String name) =>
      _repository.checkout(repoPath, name);

  Future<void> deleteBranch(String repoPath, String name) =>
      _repository.deleteBranch(repoPath, name);

  Future<void> merge(String repoPath, String name) =>
      _repository.merge(repoPath, name);
}

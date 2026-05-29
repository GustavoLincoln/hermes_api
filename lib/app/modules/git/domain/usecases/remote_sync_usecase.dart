import 'package:injectable/injectable.dart';

import '../entities/git_remote.dart';
import '../repositories/i_git_repository.dart';

@lazySingleton
class RemoteSyncUseCase {
  final IGitRepository _repository;

  const RemoteSyncUseCase(this._repository);

  Future<List<GitRemote>> listRemotes(String repoPath) =>
      _repository.remotes(repoPath);

  Future<void> addRemote(String repoPath, String name, String url) =>
      _repository.addRemote(repoPath, name, url);

  Future<void> removeRemote(String repoPath, String name) =>
      _repository.removeRemote(repoPath, name);

  Future<void> fetch(String repoPath, {String remote = 'origin'}) =>
      _repository.fetch(repoPath, remote: remote);

  Future<void> pull(
    String repoPath, {
    String remote = 'origin',
    String? branch,
  }) => _repository.pull(repoPath, remote: remote, branch: branch);

  Future<void> push(
    String repoPath, {
    String remote = 'origin',
    String? branch,
    bool setUpstream = false,
  }) => _repository.push(
    repoPath,
    remote: remote,
    branch: branch,
    setUpstream: setUpstream,
  );
}

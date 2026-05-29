import 'package:injectable/injectable.dart';

import '../../domain/entities/git_branch.dart';
import '../../domain/entities/git_commit.dart';
import '../../domain/entities/git_remote.dart';
import '../../domain/entities/git_status.dart';
import '../../domain/repositories/i_git_repository.dart';
import '../datasources/git_cli_datasource.dart';

@LazySingleton(as: IGitRepository)
class GitRepositoryImpl implements IGitRepository {
  final GitCliDatasource _datasource;

  const GitRepositoryImpl(this._datasource);

  @override
  Future<bool> isGitInstalled() => _datasource.isGitInstalled();

  @override
  Future<bool> isGitRepo(String path) => _datasource.isGitRepo(path);

  @override
  Future<void> init(String path) => _datasource.init(path);

  @override
  Future<GitStatus> status(String path) => _datasource.status(path);

  @override
  Future<void> add(String repoPath, {String? filePath}) =>
      _datasource.add(repoPath, filePath: filePath);

  @override
  Future<void> unstage(String repoPath, String filePath) =>
      _datasource.unstage(repoPath, filePath);

  @override
  Future<void> discard(String repoPath, String filePath) =>
      _datasource.discard(repoPath, filePath);

  @override
  Future<GitCommit> commit(String repoPath, String message) =>
      _datasource.commit(repoPath, message);

  @override
  Future<List<GitCommit>> log(String repoPath, {int limit = 50}) =>
      _datasource.log(repoPath, limit: limit);

  @override
  Future<List<GitBranch>> branches(String repoPath) =>
      _datasource.branches(repoPath);

  @override
  Future<void> createBranch(String repoPath, String branchName) =>
      _datasource.createBranch(repoPath, branchName);

  @override
  Future<void> checkout(String repoPath, String branchName) =>
      _datasource.checkout(repoPath, branchName);

  @override
  Future<void> deleteBranch(String repoPath, String branchName) =>
      _datasource.deleteBranch(repoPath, branchName);

  @override
  Future<void> merge(String repoPath, String branchName) =>
      _datasource.merge(repoPath, branchName);

  @override
  Future<List<GitRemote>> remotes(String repoPath) =>
      _datasource.remotes(repoPath);

  @override
  Future<void> addRemote(String repoPath, String name, String url) =>
      _datasource.addRemote(repoPath, name, url);

  @override
  Future<void> removeRemote(String repoPath, String name) =>
      _datasource.removeRemote(repoPath, name);

  @override
  Future<void> fetch(String repoPath, {String remote = 'origin'}) =>
      _datasource.fetch(repoPath, remote: remote);

  @override
  Future<void> pull(
    String repoPath, {
    String remote = 'origin',
    String? branch,
  }) => _datasource.pull(repoPath, remote: remote, branch: branch);

  @override
  Future<void> push(
    String repoPath, {
    String remote = 'origin',
    String? branch,
    bool setUpstream = false,
  }) => _datasource.push(
    repoPath,
    remote: remote,
    branch: branch,
    setUpstream: setUpstream,
  );

  @override
  Future<String> diff(
    String repoPath,
    String filePath, {
    bool staged = false,
  }) => _datasource.diff(repoPath, filePath, staged: staged);

  @override
  Future<String?> getConfig(String repoPath, String key) =>
      _datasource.getConfig(repoPath, key);

  @override
  Future<void> setConfig(String repoPath, String key, String value) =>
      _datasource.setConfig(repoPath, key, value);
}

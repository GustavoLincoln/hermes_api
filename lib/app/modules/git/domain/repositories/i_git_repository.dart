import '../entities/git_branch.dart';
import '../entities/git_commit.dart';
import '../entities/git_remote.dart';
import '../entities/git_status.dart';

abstract class IGitRepository {
  Future<bool> isGitInstalled();

  Future<bool> isGitRepo(String path);

  Future<void> init(String path);

  Future<GitStatus> status(String path);

  Future<void> add(String repoPath, {String? filePath});

  Future<void> unstage(String repoPath, String filePath);

  Future<GitCommit> commit(String repoPath, String message);

  Future<List<GitCommit>> log(String repoPath, {int limit = 50});

  Future<List<GitBranch>> branches(String repoPath);

  Future<void> createBranch(String repoPath, String branchName);

  Future<void> checkout(String repoPath, String branchName);

  Future<void> deleteBranch(String repoPath, String branchName);

  Future<void> merge(String repoPath, String branchName);

  Future<List<GitRemote>> remotes(String repoPath);

  Future<void> addRemote(String repoPath, String name, String url);

  Future<void> removeRemote(String repoPath, String name);

  Future<void> fetch(String repoPath, {String remote = 'origin'});

  Future<void> pull(
    String repoPath, {
    String remote = 'origin',
    String? branch,
  });

  Future<void> push(
    String repoPath, {
    String remote = 'origin',
    String? branch,
    bool setUpstream = false,
  });

  Future<String> diff(String repoPath, String filePath, {bool staged = false});

  Future<void> discard(String repoPath, String filePath);

  Future<String?> getConfig(String repoPath, String key);
  Future<void> setConfig(String repoPath, String key, String value);
}

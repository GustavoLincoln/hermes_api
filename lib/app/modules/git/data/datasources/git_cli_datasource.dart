import 'dart:io';

import '../../domain/entities/git_branch.dart';
import '../../domain/entities/git_commit.dart';
import '../../domain/entities/git_exceptions.dart';
import '../../domain/entities/git_file.dart';
import '../../domain/entities/git_remote.dart';
import '../../domain/entities/git_status.dart';
import '../../domain/enums/git_file_status.dart';

class GitCliDatasource {
  static const String _git = 'git';

  // ---------------------------------------------------------------------------
  // Core runner
  // ---------------------------------------------------------------------------

  Future<_GitResult> _run(
    String workingDir,
    List<String> args, {
    bool throwOnError = true,
  }) async {
    final result = await Process.run(
      _git,
      args,
      workingDirectory: workingDir,
      runInShell: Platform.isWindows,
    );

    final stdout = result.stdout as String;
    final stderr = result.stderr as String;

    if (throwOnError && result.exitCode != 0) {
      _handleError(args, result.exitCode, stderr);
    }

    return _GitResult(
      stdout: stdout.trim(),
      stderr: stderr.trim(),
      exitCode: result.exitCode,
    );
  }

  void _handleError(List<String> args, int exitCode, String stderr) {
    final command = args.join(' ');

    if (stderr.contains('not a git repository')) {
      throw GitNotARepoException(args.firstOrNull ?? '');
    }
    if (stderr.contains('CONFLICT') || stderr.contains('conflict')) {
      throw const GitMergeConflictException();
    }
    if (stderr.contains('Authentication failed') ||
        stderr.contains('could not read Username')) {
      throw const GitAuthException();
    }
    if (stderr.contains('nothing to commit')) {
      throw const GitNothingToCommitException();
    }

    throw GitException(
      message: stderr.isNotEmpty ? stderr : 'Erro ao executar: git $command',
      command: command,
      exitCode: exitCode,
      stderr: stderr,
    );
  }

  // ---------------------------------------------------------------------------
  // Install check
  // ---------------------------------------------------------------------------

  Future<bool> isGitInstalled() async {
    try {
      final result = await Process.run(_git, [
        '--version',
      ], runInShell: Platform.isWindows);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // Repo init/check
  // ---------------------------------------------------------------------------

  Future<bool> isGitRepo(String path) async {
    final result = await _run(path, [
      'rev-parse',
      '--is-inside-work-tree',
    ], throwOnError: false);
    return result.exitCode == 0;
  }

  Future<void> init(String path) async {
    await _run(path, ['init']);
  }

  // ---------------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------------

  Future<GitStatus> status(String path) async {
    final isRepo = await isGitRepo(path);
    if (!isRepo) {
      return const GitStatus(isRepo: false);
    }

    // Branch atual
    final branchResult = await _run(path, [
      'branch',
      '--show-current',
    ], throwOnError: false);
    final currentBranchName = branchResult.stdout.trim();

    // Ahead/behind
    int? aheadBy;
    int? behindBy;
    String? trackingBranch;

    if (currentBranchName.isNotEmpty) {
      final revListResult = await _run(path, [
        'rev-list',
        '--left-right',
        '--count',
        'HEAD...@{upstream}',
      ], throwOnError: false);
      if (revListResult.exitCode == 0) {
        final parts = revListResult.stdout.split(RegExp(r'\s+'));
        if (parts.length >= 2) {
          aheadBy = int.tryParse(parts[0]);
          behindBy = int.tryParse(parts[1]);
        }
      }

      final trackingResult = await _run(path, [
        'rev-parse',
        '--abbrev-ref',
        '--symbolic-full-name',
        '@{upstream}',
      ], throwOnError: false);
      if (trackingResult.exitCode == 0) {
        trackingBranch = trackingResult.stdout.trim();
      }
    }

    final currentBranch = currentBranchName.isNotEmpty
        ? GitBranch(
            name: currentBranchName,
            isCurrent: true,
            trackingBranch: trackingBranch,
            aheadBy: aheadBy,
            behindBy: behindBy,
          )
        : null;

    // Arquivos — porcelain v1
    final statusResult = await _run(path, ['status', '--porcelain']);
    final files = _parseStatusOutput(statusResult.stdout);

    final staged = files.where((f) => f.isStaged).toList();
    final unstaged = files.where((f) => !f.isStaged).toList();
    final hasConflicts = files.any((f) => f.status == GitFileStatus.conflict);

    return GitStatus(
      isRepo: true,
      currentBranch: currentBranch,
      stagedFiles: staged,
      unstagedFiles: unstaged,
      hasConflicts: hasConflicts,
    );
  }

  List<GitFile> _parseStatusOutput(String output) {
    if (output.isEmpty) return [];
    final files = <GitFile>[];

    for (final line in output.split('\n')) {
      if (line.length < 3) continue;
      final indexStatus = line[0]; // staged
      final wtStatus = line[1]; // working tree
      final filePath = line.substring(3).trim();

      // Conflito
      if ((indexStatus == 'U' || wtStatus == 'U') ||
          (indexStatus == 'A' && wtStatus == 'A') ||
          (indexStatus == 'D' && wtStatus == 'D')) {
        files.add(
          GitFile(
            path: filePath,
            status: GitFileStatus.conflict,
            isStaged: false,
          ),
        );
        continue;
      }

      // Staged
      if (indexStatus != ' ' && indexStatus != '?') {
        files.add(
          GitFile(
            path: filePath,
            status: _mapStatus(indexStatus),
            isStaged: true,
          ),
        );
      }

      // Unstaged / untracked
      if (wtStatus != ' ' && wtStatus != '?') {
        files.add(
          GitFile(
            path: filePath,
            status: _mapStatus(wtStatus),
            isStaged: false,
          ),
        );
      } else if (indexStatus == '?' && wtStatus == '?') {
        files.add(
          GitFile(
            path: filePath,
            status: GitFileStatus.untracked,
            isStaged: false,
          ),
        );
      }
    }

    return files;
  }

  GitFileStatus _mapStatus(String code) {
    switch (code) {
      case 'A':
        return GitFileStatus.added;
      case 'M':
        return GitFileStatus.modified;
      case 'D':
        return GitFileStatus.deleted;
      case 'R':
        return GitFileStatus.renamed;
      default:
        return GitFileStatus.modified;
    }
  }

  // ---------------------------------------------------------------------------
  // Stage / Unstage / Discard
  // ---------------------------------------------------------------------------

  Future<void> add(String repoPath, {String? filePath}) async {
    await _run(repoPath, ['add', filePath ?? '.']);
  }

  Future<void> unstage(String repoPath, String filePath) async {
    await _run(repoPath, ['restore', '--staged', filePath]);
  }

  Future<void> discard(String repoPath, String filePath) async {
    await _run(repoPath, ['restore', filePath]);
  }

  // ---------------------------------------------------------------------------
  // Commit
  // ---------------------------------------------------------------------------

  Future<GitCommit> commit(String repoPath, String message) async {
    await _run(repoPath, ['commit', '-m', message]);
    // Retorna o commit mais recente
    final commits = await log(repoPath, limit: 1);
    return commits.first;
  }

  // ---------------------------------------------------------------------------
  // Log
  // ---------------------------------------------------------------------------

  Future<List<GitCommit>> log(String repoPath, {int limit = 50}) async {
    // Formato: hash|shortHash|message|author|email|timestamp|parents
    const separator = '||HERMES||';
    const format =
        '%H$separator%h$separator%s$separator%an$separator%ae$separator%at$separator%P';

    final result = await _run(repoPath, [
      'log',
      '--format=$format',
      '-$limit',
    ], throwOnError: false);

    if (result.exitCode != 0 || result.stdout.isEmpty) return [];

    final commits = <GitCommit>[];
    for (final line in result.stdout.split('\n')) {
      if (line.trim().isEmpty) continue;
      final parts = line.split(separator);
      if (parts.length < 6) continue;

      final timestamp = int.tryParse(parts[5]) ?? 0;
      commits.add(
        GitCommit(
          hash: parts[0],
          shortHash: parts[1],
          message: parts[2],
          author: parts[3],
          email: parts[4],
          date: DateTime.fromMillisecondsSinceEpoch(timestamp * 1000),
          parents: parts.length > 6
              ? parts[6].split(' ').where((p) => p.isNotEmpty).toList()
              : [],
        ),
      );
    }

    return commits;
  }

  // ---------------------------------------------------------------------------
  // Branches
  // ---------------------------------------------------------------------------

  Future<List<GitBranch>> branches(String repoPath) async {
    final result = await _run(repoPath, [
      'branch',
      '-a',
      '--format=%(refname:short)|%(HEAD)|%(upstream:short)',
    ], throwOnError: false);

    if (result.exitCode != 0 || result.stdout.isEmpty) return [];

    final branches = <GitBranch>[];
    for (final line in result.stdout.split('\n')) {
      if (line.trim().isEmpty) continue;
      final parts = line.split('|');
      final name = parts[0].trim();
      final isCurrent = parts.length > 1 && parts[1] == '*';
      final tracking = parts.length > 2 && parts[2].isNotEmpty
          ? parts[2]
          : null;
      final isRemote =
          name.startsWith('remotes/') || name.startsWith('origin/');

      branches.add(
        GitBranch(
          name: name,
          isCurrent: isCurrent,
          isRemote: isRemote,
          trackingBranch: tracking,
        ),
      );
    }

    return branches;
  }

  Future<void> createBranch(String repoPath, String branchName) async {
    await _run(repoPath, ['checkout', '-b', branchName]);
  }

  Future<void> checkout(String repoPath, String branchName) async {
    await _run(repoPath, ['checkout', branchName]);
  }

  Future<void> deleteBranch(String repoPath, String branchName) async {
    await _run(repoPath, ['branch', '-d', branchName]);
  }

  Future<void> merge(String repoPath, String branchName) async {
    await _run(repoPath, ['merge', branchName]);
  }

  // ---------------------------------------------------------------------------
  // Remotes
  // ---------------------------------------------------------------------------

  Future<List<GitRemote>> remotes(String repoPath) async {
    final result = await _run(repoPath, ['remote', '-v'], throwOnError: false);

    if (result.exitCode != 0 || result.stdout.isEmpty) return [];

    final remoteMap = <String, Map<String, String>>{};
    for (final line in result.stdout.split('\n')) {
      if (line.trim().isEmpty) continue;
      final parts = line.split(RegExp(r'\s+'));
      if (parts.length < 3) continue;
      final name = parts[0];
      final url = parts[1];
      final type = parts[2].replaceAll(RegExp(r'[()]'), '');
      remoteMap.putIfAbsent(name, () => {});
      remoteMap[name]![type] = url;
    }

    return remoteMap.entries.map((e) {
      return GitRemote(
        name: e.key,
        fetchUrl: e.value['fetch'] ?? '',
        pushUrl: e.value['push'] ?? '',
      );
    }).toList();
  }

  Future<void> addRemote(String repoPath, String name, String url) async {
    await _run(repoPath, ['remote', 'add', name, url]);
  }

  Future<void> removeRemote(String repoPath, String name) async {
    await _run(repoPath, ['remote', 'remove', name]);
  }

  // ---------------------------------------------------------------------------
  // Fetch / Pull / Push
  // ---------------------------------------------------------------------------

  Future<void> fetch(String repoPath, {String remote = 'origin'}) async {
    await _run(repoPath, ['fetch', remote]);
  }

  Future<void> pull(
    String repoPath, {
    String remote = 'origin',
    String? branch,
  }) async {
    final args = ['pull', remote];
    if (branch != null) args.add(branch);
    await _run(repoPath, args);
  }

  Future<void> push(
    String repoPath, {
    String remote = 'origin',
    String? branch,
    bool setUpstream = false,
  }) async {
    final args = ['push'];
    if (setUpstream)
      args.addAll(['-u', remote, branch ?? 'HEAD']);
    else {
      args.add(remote);
      if (branch != null) args.add(branch);
    }
    await _run(repoPath, args);
  }

  // ---------------------------------------------------------------------------
  // Diff
  // ---------------------------------------------------------------------------

  Future<String> diff(
    String repoPath,
    String filePath, {
    bool staged = false,
  }) async {
    final args = ['diff'];
    if (staged) args.add('--staged');
    args.add(filePath);
    final result = await _run(repoPath, args, throwOnError: false);
    return result.stdout;
  }

  // ---------------------------------------------------------------------------
  // Config
  // ---------------------------------------------------------------------------

  Future<String?> getConfig(String repoPath, String key) async {
    final result = await _run(repoPath, ['config', key], throwOnError: false);
    if (result.exitCode != 0) return null;
    return result.stdout.trim().isEmpty ? null : result.stdout.trim();
  }

  Future<void> setConfig(String repoPath, String key, String value) async {
    await _run(repoPath, ['config', key, value]);
  }
}

// ---------------------------------------------------------------------------
// Internal model
// ---------------------------------------------------------------------------

class _GitResult {
  final String stdout;
  final String stderr;
  final int exitCode;

  const _GitResult({
    required this.stdout,
    required this.stderr,
    required this.exitCode,
  });
}

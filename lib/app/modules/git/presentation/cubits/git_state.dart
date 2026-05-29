import '../../domain/entities/git_branch.dart';
import '../../domain/entities/git_commit.dart';
import '../../domain/entities/git_remote.dart';
import '../../domain/entities/git_status.dart';

enum GitPanelTab { changes, history, branches, remotes }

enum GitOperationStatus { idle, loading, success, failure }

class GitState {
  final String repoPath;
  final bool isGitInstalled;
  final GitStatus? status;
  final List<GitCommit> commits;
  final List<GitBranch> branches;
  final List<GitRemote> remotes;
  final String? diff;
  final String? selectedFilePath;

  // UI state
  final GitPanelTab activeTab;
  final GitOperationStatus operationStatus;
  final String? operationMessage;
  final String? errorMessage;
  final Set<String> selectedFiles;

  const GitState({
    this.repoPath = '',
    this.isGitInstalled = true,
    this.status,
    this.commits = const [],
    this.branches = const [],
    this.remotes = const [],
    this.diff,
    this.selectedFilePath,
    this.activeTab = GitPanelTab.changes,
    this.operationStatus = GitOperationStatus.idle,
    this.operationMessage,
    this.errorMessage,
    this.selectedFiles = const {},
  });

  bool get isLoading => operationStatus == GitOperationStatus.loading;
  bool get hasError => errorMessage != null;
  bool get isRepo => status?.isRepo ?? false;

  GitState copyWith({
    String? repoPath,
    bool? isGitInstalled,
    GitStatus? status,
    List<GitCommit>? commits,
    List<GitBranch>? branches,
    List<GitRemote>? remotes,
    String? diff,
    String? selectedFilePath,
    GitPanelTab? activeTab,
    GitOperationStatus? operationStatus,
    String? operationMessage,
    String? errorMessage,
    Set<String>? selectedFiles,
    bool clearError = false,
    bool clearDiff = false,
    bool clearMessage = false,
  }) {
    return GitState(
      repoPath: repoPath ?? this.repoPath,
      isGitInstalled: isGitInstalled ?? this.isGitInstalled,
      status: status ?? this.status,
      commits: commits ?? this.commits,
      branches: branches ?? this.branches,
      remotes: remotes ?? this.remotes,
      diff: clearDiff ? null : (diff ?? this.diff),
      selectedFilePath: selectedFilePath ?? this.selectedFilePath,
      activeTab: activeTab ?? this.activeTab,
      operationStatus: operationStatus ?? this.operationStatus,
      operationMessage: clearMessage
          ? null
          : (operationMessage ?? this.operationMessage),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedFiles: selectedFiles ?? this.selectedFiles,
    );
  }
}

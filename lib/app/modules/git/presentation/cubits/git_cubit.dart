import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/git_exceptions.dart';
import '../../domain/repositories/i_git_repository.dart';
import '../../domain/usecases/branch_usecase.dart';
import '../../domain/usecases/commit_usecase.dart';
import '../../domain/usecases/get_git_status_usecase.dart';
import '../../domain/usecases/get_log_usecase.dart';
import '../../domain/usecases/remote_sync_usecase.dart';
import '../../domain/usecases/stage_files_usecase.dart';
import 'git_state.dart';

@injectable
class GitCubit extends Cubit<GitState> {
  final IGitRepository _repository;
  final GetGitStatusUseCase _getStatus;
  final CommitUseCase _commit;
  final StageFilesUseCase _stage;
  final GetLogUseCase _getLog;
  final BranchUseCase _branch;
  final RemoteSyncUseCase _remoteSync;

  GitCubit(
    this._repository,
    this._getStatus,
    this._commit,
    this._stage,
    this._getLog,
    this._branch,
    this._remoteSync,
  ) : super(const GitState());

  // ---------------------------------------------------------------------------
  // Init
  // ---------------------------------------------------------------------------

  Future<void> init(String repoPath) async {
    final installed = await _repository.isGitInstalled();
    if (!installed) {
      emit(state.copyWith(isGitInstalled: false));
      return;
    }
    emit(state.copyWith(repoPath: repoPath, isGitInstalled: true));
    await refresh();
  }

  Future<void> initRepo() async {
    await _run(() async {
      await _repository.init(state.repoPath);
      await refresh();
    }, successMessage: 'Repositório inicializado com sucesso.');
  }

  // ---------------------------------------------------------------------------
  // Refresh geral
  // ---------------------------------------------------------------------------

  Future<void> refresh() async {
    if (state.repoPath.isEmpty) return;
    await _run(() async {
      final status = await _getStatus(state.repoPath);
      emit(state.copyWith(status: status, clearError: true));

      if (status.isRepo) {
        final commits = await _getLog(state.repoPath, limit: 50);
        final branches = await _branch.listBranches(state.repoPath);
        final remotes = await _remoteSync.listRemotes(state.repoPath);
        emit(
          state.copyWith(
            commits: commits,
            branches: branches,
            remotes: remotes,
          ),
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Tab
  // ---------------------------------------------------------------------------

  void setTab(GitPanelTab tab) {
    emit(state.copyWith(activeTab: tab));
  }

  // ---------------------------------------------------------------------------
  // Stage
  // ---------------------------------------------------------------------------

  Future<void> stageFile(String filePath) async {
    await _run(() async {
      await _stage.stageFile(state.repoPath, filePath);
      await _refreshStatus();
    });
  }

  Future<void> stageAll() async {
    await _run(() async {
      await _stage.stageAll(state.repoPath);
      await _refreshStatus();
    }, successMessage: 'Todos os arquivos adicionados ao stage.');
  }

  Future<void> unstageFile(String filePath) async {
    await _run(() async {
      await _stage.unstageFile(state.repoPath, filePath);
      await _refreshStatus();
    });
  }

  Future<void> discardFile(String filePath) async {
    await _run(() async {
      await _stage.discardFile(state.repoPath, filePath);
      await _refreshStatus();
    });
  }

  // ---------------------------------------------------------------------------
  // Diff
  // ---------------------------------------------------------------------------

  Future<void> viewDiff(String filePath, {bool staged = false}) async {
    await _run(() async {
      emit(state.copyWith(selectedFilePath: filePath));
      final diff = await _repository.diff(
        state.repoPath,
        filePath,
        staged: staged,
      );
      emit(state.copyWith(diff: diff));
    });
  }

  void clearDiff() => emit(state.copyWith(clearDiff: true));

  // ---------------------------------------------------------------------------
  // Commit
  // ---------------------------------------------------------------------------

  Future<void> commit(String message) async {
    await _run(() async {
      await _commit(state.repoPath, message);
      await refresh();
    }, successMessage: 'Commit realizado com sucesso.');
  }

  // ---------------------------------------------------------------------------
  // Branches
  // ---------------------------------------------------------------------------

  Future<void> createBranch(String name) async {
    await _run(() async {
      await _branch.createBranch(state.repoPath, name);
      await refresh();
    }, successMessage: 'Branch "$name" criado.');
  }

  Future<void> checkout(String name) async {
    await _run(() async {
      await _branch.checkout(state.repoPath, name);
      await refresh();
    }, successMessage: 'Checkout para "$name" realizado.');
  }

  Future<void> deleteBranch(String name) async {
    await _run(() async {
      await _branch.deleteBranch(state.repoPath, name);
      await refresh();
    }, successMessage: 'Branch "$name" deletado.');
  }

  Future<void> merge(String branchName) async {
    await _run(() async {
      await _branch.merge(state.repoPath, branchName);
      await refresh();
    }, successMessage: 'Merge de "$branchName" realizado.');
  }

  // ---------------------------------------------------------------------------
  // Remotes
  // ---------------------------------------------------------------------------

  Future<void> addRemote(String name, String url) async {
    await _run(() async {
      await _remoteSync.addRemote(state.repoPath, name, url);
      final remotes = await _remoteSync.listRemotes(state.repoPath);
      emit(state.copyWith(remotes: remotes));
    }, successMessage: 'Remote "$name" adicionado.');
  }

  Future<void> removeRemote(String name) async {
    await _run(() async {
      await _remoteSync.removeRemote(state.repoPath, name);
      final remotes = await _remoteSync.listRemotes(state.repoPath);
      emit(state.copyWith(remotes: remotes));
    }, successMessage: 'Remote "$name" removido.');
  }

  Future<void> fetch({String remote = 'origin'}) async {
    await _run(() async {
      await _remoteSync.fetch(state.repoPath, remote: remote);
      await refresh();
    }, successMessage: 'Fetch de "$remote" concluído.');
  }

  Future<void> pull({String remote = 'origin', String? branch}) async {
    await _run(() async {
      await _remoteSync.pull(state.repoPath, remote: remote, branch: branch);
      await refresh();
    }, successMessage: 'Pull de "$remote" concluído.');
  }

  Future<void> push({
    String remote = 'origin',
    String? branch,
    bool setUpstream = false,
  }) async {
    await _run(() async {
      await _remoteSync.push(
        state.repoPath,
        remote: remote,
        branch: branch,
        setUpstream: setUpstream,
      );
      await refresh();
    }, successMessage: 'Push para "$remote" concluído.');
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Future<void> _refreshStatus() async {
    final status = await _getStatus(state.repoPath);
    emit(state.copyWith(status: status));
  }

  Future<void> _run(
    Future<void> Function() action, {
    String? successMessage,
  }) async {
    emit(
      state.copyWith(
        operationStatus: GitOperationStatus.loading,
        clearError: true,
        clearMessage: true,
      ),
    );
    try {
      await action();
      emit(
        state.copyWith(
          operationStatus: GitOperationStatus.success,
          operationMessage: successMessage,
        ),
      );
    } on GitException catch (e) {
      emit(
        state.copyWith(
          operationStatus: GitOperationStatus.failure,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          operationStatus: GitOperationStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

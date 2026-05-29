import 'package:hermes_api/app/modules/git/domain/entities/git_branch.dart';
import 'package:hermes_api/app/modules/git/domain/entities/git_file.dart';

class GitStatus {
  final bool isRepo;
  final GitBranch? currentBranch;
  final List<GitFile> stagedFiles;
  final List<GitFile> unstagedFiles;
  final bool hasConflicts;

  const GitStatus({
    required this.isRepo,
    this.currentBranch,
    this.stagedFiles = const [],
    this.unstagedFiles = const [],
    this.hasConflicts = false,
  });

  bool get isClean => stagedFiles.isEmpty && unstagedFiles.isEmpty;
  bool get hasChanges => !isClean;
  int get totalChanges => stagedFiles.length + unstagedFiles.length;
}

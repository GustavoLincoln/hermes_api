enum GitFileStatus {
  added,
  modified,
  deleted,
  renamed,
  untracked,
  staged,
  conflict,
}

extension GitFileStatusExtension on GitFileStatus {
  String get label {
    switch (this) {
      case GitFileStatus.added:
        return 'Added';
      case GitFileStatus.modified:
        return 'Modified';
      case GitFileStatus.deleted:
        return 'Deleted';
      case GitFileStatus.renamed:
        return 'Renamed';
      case GitFileStatus.untracked:
        return 'Untracked';
      case GitFileStatus.staged:
        return 'Staged';
      case GitFileStatus.conflict:
        return 'Conflict';
    }
  }
}

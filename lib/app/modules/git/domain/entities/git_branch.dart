class GitBranch {
  final String name;
  final bool isCurrent;
  final bool isRemote;
  final String? trackingBranch;
  final int? aheadBy;
  final int? behindBy;

  const GitBranch({
    required this.name,
    this.isCurrent = false,
    this.isRemote = false,
    this.trackingBranch,
    this.aheadBy,
    this.behindBy,
  });

  bool get hasTracking => trackingBranch != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitBranch &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

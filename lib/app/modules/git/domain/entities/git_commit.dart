class GitCommit {
  final String hash;
  final String shortHash;
  final String message;
  final String author;
  final String email;
  final DateTime date;
  final List<String> parents;

  const GitCommit({
    required this.hash,
    required this.shortHash,
    required this.message,
    required this.author,
    required this.email,
    required this.date,
    this.parents = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitCommit &&
          runtimeType == other.runtimeType &&
          hash == other.hash;

  @override
  int get hashCode => hash.hashCode;
}

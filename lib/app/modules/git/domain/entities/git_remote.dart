class GitRemote {
  final String name;
  final String fetchUrl;
  final String pushUrl;

  const GitRemote({
    required this.name,
    required this.fetchUrl,
    required this.pushUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitRemote &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

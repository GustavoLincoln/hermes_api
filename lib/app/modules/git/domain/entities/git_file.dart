import 'package:hermes_api/app/modules/git/domain/enums/git_file_status.dart';

class GitFile {
  final String path;
  final GitFileStatus status;
  final bool isStaged;

  const GitFile({
    required this.path,
    required this.status,
    this.isStaged = false,
  });

  String get filename => path.split('/').last;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GitFile &&
          runtimeType == other.runtimeType &&
          path == other.path &&
          status == other.status &&
          isStaged == other.isStaged;

  @override
  int get hashCode => path.hashCode ^ status.hashCode ^ isStaged.hashCode;
}

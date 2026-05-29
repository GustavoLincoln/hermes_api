class GitException implements Exception {
  final String message;
  final String? command;
  final int? exitCode;
  final String? stderr;

  const GitException({
    required this.message,
    this.command,
    this.exitCode,
    this.stderr,
  });

  @override
  String toString() =>
      'GitException: $message'
      '${command != null ? ' (command: $command)' : ''}'
      '${exitCode != null ? ' [exit: $exitCode]' : ''}';
}

class GitNotInstalledException extends GitException {
  const GitNotInstalledException()
    : super(message: 'Git não está instalado ou não foi encontrado no PATH.');
}

class GitNotARepoException extends GitException {
  const GitNotARepoException(String path)
    : super(message: 'O diretório "$path" não é um repositório git.');
}

class GitMergeConflictException extends GitException {
  const GitMergeConflictException()
    : super(
        message:
            'Merge conflict detectado. Resolva os conflitos antes de continuar.',
      );
}

class GitAuthException extends GitException {
  const GitAuthException()
    : super(message: 'Falha de autenticação com o repositório remoto.');
}

class GitNothingToCommitException extends GitException {
  const GitNothingToCommitException()
    : super(message: 'Nenhuma mudança no stage para commitar.');
}

import 'package:equatable/equatable.dart';

import '../../../../shared/entities/key_value_entry.dart';

class EnvironmentEntity extends Equatable {
  const EnvironmentEntity({
    required this.id,
    required this.name,
    this.variables = const <KeyValueEntry>[],
  });

  final String id;
  final String name;
  final List<KeyValueEntry> variables;

  @override
  List<Object?> get props => <Object?>[id, name, variables];
}

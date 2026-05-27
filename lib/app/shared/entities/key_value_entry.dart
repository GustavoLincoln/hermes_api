import 'package:equatable/equatable.dart';

class KeyValueEntry extends Equatable {
  const KeyValueEntry({
    required this.key,
    required this.value,
    this.enabled = true,
  });

  final String key;
  final String value;
  final bool enabled;

  bool get isValid => key.trim().isNotEmpty;

  KeyValueEntry copyWith({
    String? key,
    String? value,
    bool? enabled,
  }) {
    return KeyValueEntry(
      key: key ?? this.key,
      value: value ?? this.value,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'key': key,
      'value': value,
      'enabled': enabled,
    };
  }

  factory KeyValueEntry.fromJson(Map<String, dynamic> json) {
    return KeyValueEntry(
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? true,
    );
  }

  @override
  List<Object?> get props => <Object?>[key, value, enabled];
}

import 'package:fluent_ui/fluent_ui.dart';

import '../../../../core/ui/styles/colors_app.dart';
import '../../../../core/ui/styles/text_styles.dart';

class StatusCodePillWidget extends StatelessWidget {
  const StatusCodePillWidget({required this.statusCode, super.key});

  final int? statusCode;

  @override
  Widget build(BuildContext context) {
    final tone = _statusTone(statusCode);

    return Tooltip(
      message: tone.message,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: tone.background,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: tone.border),
        ),
        child: Text(
          'Status: ${statusCode ?? '-'}',
          style: TextStyles.caption.copyWith(
            color: tone.foreground,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

_StatusTone _statusTone(int? statusCode) {
  if (statusCode == null) {
    return const _StatusTone(
      foreground: Color(0xFFF3F5F7),
      background: Color(0x331A1D21),
      border: Color(0x443D434C),
      message: '',
    );
  }

  if (statusCode >= 200 && statusCode < 300) {
    return const _StatusTone(
      foreground: ColorsApp.success,
      background: Color(0x1F73C991),
      border: Color(0x4473C991),
      message: 'Request successful. The server has responded as required.',
    );
  }

  if (statusCode >= 300 && statusCode < 400) {
    return const _StatusTone(
      foreground: ColorsApp.info,
      background: Color(0x1F8BB8FF),
      border: Color(0x448BB8FF),
      message: '',
    );
  }

  if (statusCode >= 400 && statusCode < 500) {
    return const _StatusTone(
      foreground: ColorsApp.warning,
      background: Color(0x1FE9C400),
      border: Color(0x44E9C400),
      message: '',
    );
  }

  if (statusCode >= 500) {
    return const _StatusTone(
      foreground: ColorsApp.error,
      background: Color(0x1FFFB4AB),
      border: Color(0x44FFB4AB),
      message: '',
    );
  }

  return const _StatusTone(
    foreground: Color(0xFFF3F5F7),
    background: Color(0x331A1D21),
    border: Color(0x443D434C),
    message: '',
  );
}

class _StatusTone {
  const _StatusTone({
    required this.foreground,
    required this.background,
    required this.border,
    required this.message,
  });

  final Color foreground;
  final Color background;
  final Color border;
  final String message;
}

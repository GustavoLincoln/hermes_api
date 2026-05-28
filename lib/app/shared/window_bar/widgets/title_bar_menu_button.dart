import 'package:fluent_ui/fluent_ui.dart';

import '../../../core/theme/app_theme.dart';

class TitleBarMenuButton extends StatelessWidget {
  const TitleBarMenuButton({
    required this.onPressed,
    this.isMenuOpen = false,
    super.key,
  });

  final VoidCallback onPressed;
  final bool isMenuOpen;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: Button(
        onPressed: onPressed,
        style: ButtonStyle(
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return AppTheme.surfaceHighest.withValues(alpha: 0.72);
            }
            if (states.contains(WidgetState.hovered)) {
              return AppTheme.surfaceHigh.withValues(alpha: 0.88);
            }
            return Colors.transparent;
          }),
        ),
        child: Center(
          child: Icon(
            isMenuOpen
                ? FluentIcons.close_pane_mirrored
                : FluentIcons.global_nav_button,
            size: isMenuOpen ? 14 : 14,
          ),
        ),
      ),
    );
  }
}

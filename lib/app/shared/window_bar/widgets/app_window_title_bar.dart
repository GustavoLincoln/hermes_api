import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hermes_api/app/shared/window_bar/widgets/title_bar_menu_button.dart';
import 'package:hermes_api/app/shared/window_bar/widgets/title_bar_search_field.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

class AppWindowTitleBar extends StatelessWidget {
  const AppWindowTitleBar({
    required this.sectionTitle,
    required this.onToggleMenu,
    super.key,
    this.searchPlaceholder = 'Search requests, collections or environments',
    this.isMenuOpen = false,
  });

  final String sectionTitle;
  final String searchPlaceholder;
  final VoidCallback onToggleMenu;
  final bool isMenuOpen;

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(left: 12, right: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceLow.withValues(alpha: 0.94),
          border: const Border(
            bottom: BorderSide(color: AppTheme.outlineVariant),
          ),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: MoveWindow(
                child: Row(
                  children: <Widget>[
                    TitleBarMenuButton(
                      onPressed: onToggleMenu,
                      isMenuOpen: isMenuOpen,
                    ),
                    const SizedBox(width: 10),
                    const HermesBrandBadge(),
                    const SizedBox(width: 10),
                    Text(
                      AppConstants.appName,
                      style: AppTheme.bodyLgStyle.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      sectionTitle,
                      style: AppTheme.captionStyle.copyWith(fontSize: 12),
                    ),
                    const SizedBox(width: 18),
                    Flexible(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 320),
                            child: TitleBarSearchField(
                              placeholder: searchPlaceholder,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
            const WindowCaptionButtons(),
          ],
        ),
      ),
    );
  }
}

class HermesBrandBadge extends StatelessWidget {
  const HermesBrandBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer,
        borderRadius: BorderRadius.circular(AppTheme.radius),
      ),
      child: const Icon(FluentIcons.send, size: 13, color: AppTheme.onPrimary),
    );
  }
}

class WindowCaptionButtons extends StatelessWidget {
  const WindowCaptionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: AppTheme.onSurfaceVariant,
      mouseOver: AppTheme.surfaceHigh,
      mouseDown: AppTheme.surfaceHighest,
      iconMouseOver: AppTheme.onSurface,
      iconMouseDown: AppTheme.onSurface,
    );

    final closeColors = WindowButtonColors(
      iconNormal: AppTheme.onSurfaceVariant,
      mouseOver: const Color(0xFF93000A),
      mouseDown: const Color(0xFF690005),
      iconMouseOver: AppTheme.error,
      iconMouseDown: AppTheme.error,
    );

    return Row(
      children: <Widget>[
        MinimizeWindowButton(colors: buttonColors),
        MaximizeWindowButton(colors: buttonColors),
        CloseWindowButton(colors: closeColors),
      ],
    );
  }
}

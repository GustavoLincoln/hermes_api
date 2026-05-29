import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hermes_api/app/shared/window_bar/widgets/title_bar_menu_button.dart';
import 'package:hermes_api/app/shared/window_bar/widgets/title_bar_search_field.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/ui/styles/radius_app.dart';
import '../../../core/ui/styles/text_styles.dart';

class AppWindowTitleBar extends StatelessWidget {
  const AppWindowTitleBar({
    required this.sectionTitle,
    required this.onToggleMenu,
    super.key,
    this.searchPlaceholder = 'Search requests, collections or environments',
    this.isMenuOpen = false,
    this.height = 56,
  });

  final String sectionTitle;
  final String searchPlaceholder;
  final VoidCallback onToggleMenu;
  final bool isMenuOpen;
  final double height;

  @override
  Widget build(BuildContext context) {
    return WindowTitleBarBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showSearch = constraints.maxWidth >= 720;
          final showSectionTitle = constraints.maxWidth >= 520;
          final showBrandText = constraints.maxWidth >= 300;
          final compactSpacing = constraints.maxWidth < 240;

          return Container(
            height: height,
            padding: EdgeInsets.only(
              left: compactSpacing ? 6 : 12,
              right: 8,
            ),
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
                        SizedBox(width: compactSpacing ? 6 : 10),
                        const HermesBrandBadge(),
                        if (showBrandText) ...<Widget>[
                          SizedBox(width: compactSpacing ? 6 : 10),
                          Flexible(
                            child: Text(
                              AppConstants.appName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.bodyLg.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                        if (showSectionTitle) ...<Widget>[
                          SizedBox(width: compactSpacing ? 6 : 10),
                          Flexible(
                            child: Text(
                              sectionTitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyles.caption.copyWith(fontSize: 12),
                            ),
                          ),
                        ],
                        if (showSearch) ...<Widget>[
                          const SizedBox(width: 18),
                          Flexible(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxWidth: 320),
                                  child: TitleBarSearchField(
                                    placeholder: searchPlaceholder,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                ),
                const WindowCaptionButtons(),
              ],
            ),
          );
        },
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
        borderRadius: BorderRadius.circular(RadiusApp.base),
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

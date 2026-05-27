import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:hermes_api/app/shared/window_bar/widgets/title_bar_search_field.dart';

import '../../../core/constants/app_constants.dart';

class AppWindowTitleBar extends StatelessWidget {
  const AppWindowTitleBar({
    required this.sectionTitle,
    required this.onToggleMenu,
    super.key,
    this.searchPlaceholder = 'Search requests, collections or environments',
  });

  final String sectionTitle;
  final String searchPlaceholder;
  final VoidCallback onToggleMenu;

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);

    return WindowTitleBarBox(
      child: Container(
        height: 56,
        padding: const EdgeInsets.only(left: 12, right: 8),
        decoration: BoxDecoration(
          color: const Color(0x44181B20),
          border: Border(bottom: BorderSide(color: const Color(0x443D434C))),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: MoveWindow(
                child: Row(
                  children: <Widget>[
                    TitleBarMenuButton(onPressed: onToggleMenu),
                    const SizedBox(width: 10),
                    const HermesBrandBadge(),
                    const SizedBox(width: 10),
                    Text(
                      AppConstants.appName,
                      style: theme.typography.bodyLarge?.copyWith(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      sectionTitle,
                      style: theme.typography.caption?.copyWith(
                        fontSize: 12,
                        color: const Color(0xFFB7BEC8),
                      ),
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

class TitleBarMenuButton extends StatelessWidget {
  const TitleBarMenuButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

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
              return const Color(0x331A1D21);
            }
            if (states.contains(WidgetState.hovered)) {
              return const Color(0x221A1D21);
            }
            return Colors.transparent;
          }),
        ),
        child: const Center(
          child: Icon(FluentIcons.global_nav_button, size: 14),
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
        color: const Color(0xFFFFD700),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(FluentIcons.send, size: 13, color: Color(0xFF3A3000)),
    );
  }
}

class WindowCaptionButtons extends StatelessWidget {
  const WindowCaptionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonColors = WindowButtonColors(
      iconNormal: const Color(0xFFB7BEC8),
      mouseOver: const Color(0x221A1D21),
      mouseDown: const Color(0x441A1D21),
      iconMouseOver: Colors.white,
      iconMouseDown: Colors.white,
    );

    final closeColors = WindowButtonColors(
      iconNormal: const Color(0xFFB7BEC8),
      mouseOver: const Color(0xFFD13438),
      mouseDown: const Color(0xFFA4262C),
      iconMouseOver: Colors.white,
      iconMouseDown: Colors.white,
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

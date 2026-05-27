import 'package:fluent_ui/fluent_ui.dart';

class AppTheme {
  const AppTheme._();

  static FluentThemeData dark() {
    const background = Color(0xFF111315);
    const layer = Color(0xCC1A1D21);
    const accent = Color(0xFFFFD700);
    const accentDark = Color(0xFF3A3000);

    return FluentThemeData(
      brightness: Brightness.dark,
      accentColor: AccentColor.swatch(const <String, Color>{
        'darkest': Color(0xFF5A4700),
        'darker': Color(0xFF856800),
        'dark': Color(0xFFB08B00),
        'normal': accent,
        'light': Color(0xFFFFE66F),
        'lighter': Color(0xFFFFEEA3),
        'lightest': Color(0xFFFFF6D6),
      }),
      scaffoldBackgroundColor: Colors.transparent,
      micaBackgroundColor: background,
      acrylicBackgroundColor: layer,
      cardColor: const Color(0xDD20242A),
      inactiveBackgroundColor: layer,
      shadowColor: Colors.black.withValues(alpha: 0.18),
      visualDensity: VisualDensity.standard,
      iconTheme: const IconThemeData(
        color: Color(0xFFB7BEC8),
        size: 18,
      ),
      fontFamily: 'Inter',
      typography: Typography.raw(
        display: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xFFF3F5F7),
        ),
        title: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF3F5F7),
        ),
        subtitle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF3F5F7),
        ),
        body: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: Color(0xFFF3F5F7),
        ),
        bodyStrong: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF3F5F7),
        ),
        caption: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Color(0xFFB7BEC8),
        ),
      ),
      buttonTheme: ButtonThemeData(
        filledButtonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFFE7C100);
            }
            if (states.contains(WidgetState.hovered)) {
              return const Color(0xFFFFE15A);
            }
            return accent;
          }),
          foregroundColor: const WidgetStatePropertyAll(accentDark),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  static BoxDecoration panelDecoration({
    double opacity = 0.78,
    bool elevated = false,
  }) {
    return BoxDecoration(
      color: (elevated ? const Color(0xFF20242A) : const Color(0xFF171A1F))
          .withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0x443D434C)),
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.black.withValues(alpha: elevated ? 0.22 : 0.14),
          blurRadius: elevated ? 30 : 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

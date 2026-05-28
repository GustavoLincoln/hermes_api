import 'package:fluent_ui/fluent_ui.dart';

class AppTheme {
  const AppTheme._();

  static const Color background = Color(0xFF131313);
  static const Color surface = Color(0xFF131313);
  static const Color surfaceDim = Color(0xFF131313);
  static const Color surfaceBright = Color(0xFF393939);
  static const Color surfaceLowest = Color(0xFF0E0E0E);
  static const Color surfaceLow = Color(0xFF1C1B1B);
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceHigh = Color(0xFF2A2A2A);
  static const Color surfaceHighest = Color(0xFF353534);
  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFD0C6AB);
  static const Color inverseSurface = Color(0xFFE5E2E1);
  static const Color inverseOnSurface = Color(0xFF313030);
  static const Color outline = Color(0xFF999077);
  static const Color outlineVariant = Color(0xFF4D4732);
  static const Color surfaceTint = Color(0xFFE9C400);
  static const Color primary = Color(0xFFFFF6DF);
  static const Color onPrimary = Color(0xFF3A3000);
  static const Color primaryContainer = Color(0xFFFFD700);
  static const Color onPrimaryContainer = Color(0xFF705E00);
  static const Color secondary = Color(0xFFFFDE56);
  static const Color onSecondary = Color(0xFF3A3000);
  static const Color secondaryContainer = Color(0xFFE5C100);
  static const Color onSecondaryContainer = Color(0xFF604F00);
  static const Color tertiary = Color(0xFFF8F6F5);
  static const Color onTertiary = Color(0xFF303030);
  static const Color tertiaryContainer = Color(0xFFDBD9D9);
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color success = Color(0xFF73C991);
  static const Color successMuted = Color(0xFF234031);
  static const Color info = Color(0xFF8BB8FF);
  static const Color warning = Color(0xFFE9C400);

  static const double radiusSm = 4;
  static const double radius = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;

  static const double spacingXs = 4;
  static const double spacingSm = 12;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;

  static FluentThemeData dark() {
    return FluentThemeData(
      brightness: Brightness.dark,
      accentColor: AccentColor.swatch(const <String, Color>{
        'darkest': Color(0xFF221B00),
        'darker': Color(0xFF544600),
        'dark': Color(0xFF705D00),
        'normal': primaryContainer,
        'light': Color(0xFFFFE16D),
        'lighter': Color(0xFFFFEEAA),
        'lightest': primary,
      }),
      scaffoldBackgroundColor: Colors.transparent,
      micaBackgroundColor: background,
      acrylicBackgroundColor: surfaceLow,
      cardColor: surfaceContainer,
      inactiveBackgroundColor: surfaceLow,
      shadowColor: Colors.transparent,
      visualDensity: VisualDensity.standard,
      iconTheme: const IconThemeData(
        color: onSurfaceVariant,
        size: 18,
      ),
      fontFamily: 'Inter',
      focusTheme: FocusThemeData(
        glowFactor: 0,
        primaryBorder: BorderSide(
          color: primaryContainer.withValues(alpha: 0.95),
          width: 1.4,
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thickness: 4,
      ),
      typography: Typography.raw(
        display: headlineLgStyle,
        title: headlineSmStyle,
        subtitle: bodyMdStyle.copyWith(
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        body: bodyMdStyle,
        bodyStrong: bodyMdStyle.copyWith(
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        caption: captionStyle,
      ),
      buttonTheme: ButtonThemeData(
        filledButtonStyle: _primaryButtonStyle(),
      ),
    );
  }

  static BoxDecoration panelDecoration({
    double opacity = 1,
    bool elevated = false,
  }) {
    final color = (elevated ? surfaceHigh : surfaceContainer).withValues(
      alpha: opacity,
    );

    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radiusLg),
      border: Border.all(color: outlineVariant),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          color.withValues(alpha: 1),
          color.withValues(alpha: 0.96),
        ],
      ),
    );
  }

  static TextStyle get headlineLgStyle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.64,
        color: onSurface,
      );

  static TextStyle get headlineMdStyle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: -0.24,
        color: onSurface,
      );

  static TextStyle get headlineSmStyle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: onSurface,
      );

  static TextStyle get bodyLgStyle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: onSurface,
      );

  static TextStyle get bodyMdStyle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        color: onSurface,
      );

  static TextStyle get codeMdStyle => const TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.57,
        color: onSurface,
      );

  static TextStyle get codeSmStyle => const TextStyle(
        fontFamily: 'JetBrains Mono',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: onSurface,
      );

  static TextStyle get labelCapsStyle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.45,
        letterSpacing: 0.55,
        color: onSurfaceVariant,
      );

  static TextStyle get captionStyle => const TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: onSurfaceVariant,
      );

  static ButtonStyle _primaryButtonStyle() {
    return ButtonStyle(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
      foregroundColor: const WidgetStatePropertyAll(onPrimary),
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.disabled)) {
          return primaryContainer.withValues(alpha: 0.35);
        }
        if (states.contains(WidgetState.pressed)) {
          return secondaryContainer;
        }
        if (states.contains(WidgetState.hovered)) {
          return secondary;
        }
        return primaryContainer;
      }),
    );
  }
}

import 'package:fluent_ui/fluent_ui.dart';

import '../ui/styles/colors_app.dart';
import '../ui/styles/radius_app.dart';
import '../ui/styles/text_styles.dart';

class AppTheme {
  const AppTheme._();

  static const Color background = ColorsApp.background;
  static const Color surface = ColorsApp.surface;
  static const Color surfaceDim = ColorsApp.surfaceDim;
  static const Color surfaceBright = ColorsApp.surfaceBright;
  static const Color surfaceLowest = ColorsApp.surfaceLowest;
  static const Color surfaceLow = ColorsApp.surfaceLow;
  static const Color surfaceContainer = ColorsApp.surfaceContainer;
  static const Color surfaceHigh = ColorsApp.surfaceHigh;
  static const Color surfaceHighest = ColorsApp.surfaceHighest;
  static const Color onSurface = ColorsApp.onSurface;
  static const Color onSurfaceVariant = ColorsApp.onSurfaceVariant;
  static const Color inverseSurface = ColorsApp.inverseSurface;
  static const Color inverseOnSurface = ColorsApp.inverseOnSurface;
  static const Color outline = ColorsApp.outline;
  static const Color outlineVariant = ColorsApp.outlineVariant;
  static const Color surfaceTint = ColorsApp.surfaceTint;
  static const Color primary = ColorsApp.primary;
  static const Color onPrimary = ColorsApp.onPrimary;
  static const Color primaryContainer = ColorsApp.primaryContainer;
  static const Color onPrimaryContainer = ColorsApp.onPrimaryContainer;
  static const Color secondary = ColorsApp.secondary;
  static const Color onSecondary = ColorsApp.onSecondary;
  static const Color secondaryContainer = ColorsApp.secondaryContainer;
  static const Color onSecondaryContainer = ColorsApp.onSecondaryContainer;
  static const Color tertiary = ColorsApp.tertiary;
  static const Color onTertiary = ColorsApp.onTertiary;
  static const Color tertiaryContainer = ColorsApp.tertiaryContainer;
  static const Color error = ColorsApp.error;
  static const Color onError = ColorsApp.onError;
  static const Color errorContainer = ColorsApp.errorContainer;
  static const Color success = ColorsApp.success;
  static const Color successMuted = ColorsApp.successMuted;
  static const Color info = ColorsApp.info;
  static const Color warning = ColorsApp.warning;

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
        display: TextStyles.headlineLg,
        title: TextStyles.headlineSm,
        subtitle: TextStyles.bodyMd.copyWith(
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        body: TextStyles.bodyMd,
        bodyStrong: TextStyles.bodyMd.copyWith(
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        caption: TextStyles.caption,
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
      borderRadius: BorderRadius.circular(RadiusApp.lg),
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

  static ButtonStyle _primaryButtonStyle() {
    return ButtonStyle(
      padding: const WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(RadiusApp.base),
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

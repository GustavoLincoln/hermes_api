import 'package:fluent_ui/fluent_ui.dart';

import 'colors_app.dart';

class TextStyles {
  const TextStyles._();

  static const String primaryFont = 'Inter';
  static const String codeFont = 'JetBrains Mono';

  static TextStyle get headlineLg => const TextStyle(
        fontFamily: primaryFont,
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: -0.64,
        color: ColorsApp.onSurface,
      );

  static TextStyle get headlineMd => const TextStyle(
        fontFamily: primaryFont,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: -0.24,
        color: ColorsApp.onSurface,
      );

  static TextStyle get headlineSm => const TextStyle(
        fontFamily: primaryFont,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: ColorsApp.onSurface,
      );

  static TextStyle get bodyLg => const TextStyle(
        fontFamily: primaryFont,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: ColorsApp.onSurface,
      );

  static TextStyle get bodyMd => const TextStyle(
        fontFamily: primaryFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        color: ColorsApp.onSurface,
      );

  static TextStyle get codeMd => const TextStyle(
        fontFamily: codeFont,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.57,
        color: ColorsApp.onSurface,
      );

  static TextStyle get codeSm => const TextStyle(
        fontFamily: codeFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: ColorsApp.onSurface,
      );

  static TextStyle get labelCaps => const TextStyle(
        fontFamily: primaryFont,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        height: 1.45,
        letterSpacing: 0.55,
        color: ColorsApp.onSurfaceVariant,
      );

  static TextStyle get caption => const TextStyle(
        fontFamily: primaryFont,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: ColorsApp.onSurfaceVariant,
      );
}

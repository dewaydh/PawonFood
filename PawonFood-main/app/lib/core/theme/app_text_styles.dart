import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Central Typography & TextStyle Definition for PawonFood.
/// Implements the typography hierarchy requested in Section 4.
/// Headings & Display use `BricolageGrotesque`.
/// Body & UI use `Inter`.
abstract final class AppTextStyles {
  static const fontDisplay = 'BricolageGrotesque';
  static const fontBody = 'Inter';

  static FontWeight _fw(double w) => FontWeight.values[((w / 100).round() - 1).clamp(0, 8)];

  // ── Raw Style Builders ──────────────────────────────────────────────────────

  /// Display / Heading font style (Bricolage Grotesque).
  static TextStyle displayStyle(
    double size, {
    double weight = 700,
    double? height,
    Color? color,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: fontDisplay,
        fontSize: size,
        fontWeight: _fw(weight),
        fontVariations: [FontVariation('wght', weight), const FontVariation('opsz', 16)],
        letterSpacing: letterSpacing ?? (-size * 0.02),
        height: height == null ? null : height / size,
        color: color ?? AppColors.inkOf(),
      );

  /// Body / UI font style (Inter).
  static TextStyle bodyStyle(
    double size, {
    double weight = 400,
    double? height,
    Color? color,
    double? letterSpacing,
  }) =>
      TextStyle(
        fontFamily: fontBody,
        fontSize: size,
        fontWeight: _fw(weight),
        fontVariations: [FontVariation('wght', weight)],
        letterSpacing: letterSpacing ?? 0.1,
        height: height == null ? null : height / size,
        color: color ?? AppColors.inkOf(),
      );

  // ── Section 4 Hierarchy Tokens ──────────────────────────────────────────────

  /// Display: 32px, Bold
  static TextStyle display([Color? color]) => displayStyle(32, weight: 700, height: 38, color: color);

  /// H1: 28px, Bold
  static TextStyle h1([Color? color]) => displayStyle(28, weight: 700, height: 34, color: color);

  /// H2: 24px, SemiBold
  static TextStyle h2([Color? color]) => displayStyle(24, weight: 600, height: 30, color: color);

  /// H3: 20px, SemiBold
  static TextStyle h3([Color? color]) => displayStyle(20, weight: 600, height: 26, color: color);

  /// H4: 18px, SemiBold
  static TextStyle h4([Color? color]) => displayStyle(18, weight: 600, height: 24, color: color);

  /// Body Large: 16px, Regular
  static TextStyle bodyLarge([Color? color]) => bodyStyle(16, weight: 400, height: 24, color: color);

  /// Body Medium: 14px, Regular
  static TextStyle bodyMedium([Color? color]) => bodyStyle(14, weight: 400, height: 20, color: color);

  /// Body Small: 12px, Regular
  static TextStyle bodySmall([Color? color]) => bodyStyle(12, weight: 400, height: 16, color: color);

  /// Label: 13px, Medium
  static TextStyle label([Color? color]) => displayStyle(13, weight: 500, height: 18, color: color);

  /// Button: 15px, SemiBold
  static TextStyle button([Color? color]) => displayStyle(15, weight: 600, height: 20, color: color);

  /// Caption: 11.5px, Regular
  static TextStyle caption([Color? color]) => bodyStyle(11.5, weight: 400, height: 15, color: color);

  // ── M3 TextTheme Builder ────────────────────────────────────────────────────

  static TextTheme createTextTheme(Color primaryText, Color secondaryText) {
    return TextTheme(
      displayLarge: displayStyle(32, weight: 700, height: 38, color: primaryText),
      displayMedium: displayStyle(28, weight: 700, height: 34, color: primaryText),
      displaySmall: displayStyle(24, weight: 600, height: 30, color: primaryText),
      headlineLarge: displayStyle(28, weight: 700, height: 34, color: primaryText),
      headlineMedium: displayStyle(24, weight: 600, height: 30, color: primaryText),
      headlineSmall: displayStyle(20, weight: 600, height: 26, color: primaryText),
      titleLarge: displayStyle(18, weight: 600, height: 24, color: primaryText),
      titleMedium: displayStyle(16, weight: 600, height: 22, color: primaryText),
      titleSmall: displayStyle(14, weight: 600, height: 20, color: primaryText),
      bodyLarge: bodyStyle(16, weight: 400, height: 24, color: primaryText),
      bodyMedium: bodyStyle(14, weight: 400, height: 20, color: primaryText),
      bodySmall: bodyStyle(12, weight: 400, height: 16, color: secondaryText),
      labelLarge: displayStyle(14, weight: 600, height: 20, color: primaryText),
      labelMedium: displayStyle(12, weight: 500, height: 16, color: secondaryText),
      labelSmall: bodyStyle(11, weight: 400, height: 14, color: secondaryText),
    );
  }
}


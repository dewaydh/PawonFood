import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

export 'app_text_styles.dart';

/// The system text scale (1.0 at default), capped at 2x.
double textScaleOf(BuildContext context) => (MediaQuery.textScalerOf(context).scale(16) / 16).clamp(1.0, 2.0);

/// Type scale adapter connecting existing codebase calls to [AppTextStyles].
abstract final class AppTypography {
  static TextStyle display(
    double size, {
    double weight = 700,
    double? height,
    Color? color,
    double? letterSpacing,
  }) =>
      AppTextStyles.displayStyle(
        size,
        weight: weight,
        height: height,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle text(
    double size, {
    double weight = 400,
    double? height,
    Color? color,
    double? letterSpacing,
  }) =>
      AppTextStyles.bodyStyle(
        size,
        weight: weight,
        height: height,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle labelExpressive(
    double size, {
    double weight = 700,
    double? height,
    Color? color,
  }) =>
      AppTextStyles.displayStyle(
        size,
        weight: weight,
        height: height,
        color: color,
      );

  // Named tokens matching DESIGN_SYSTEM.md & Section 4
  static TextStyle get titleXl => AppTextStyles.h1();
  static TextStyle get titleL => AppTextStyles.h2();
  static TextStyle get titleM => AppTextStyles.h4();
  static TextStyle get body => AppTextStyles.bodyLarge();
  static TextStyle get bodyMuted => AppTextStyles.bodyLarge(AppColors.inkMutedOf());
  static TextStyle get label => AppTextStyles.button();
  static TextStyle get caption => AppTextStyles.caption(AppColors.inkMutedOf());
}

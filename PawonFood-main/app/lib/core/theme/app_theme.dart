import 'package:flutter/material.dart';

import 'app_dark_theme.dart';
import 'app_light_theme.dart';

export 'app_colors.dart';
export 'app_dark_theme.dart';
export 'app_light_theme.dart';
export 'app_text_styles.dart';

/// Central Theme manager for PawonFood.
/// Exposes light and dark Material 3 themes built from dedicated theme specifications.
abstract final class AppTheme {
  /// Builds the complete Light Theme.
  static ThemeData light() => AppLightTheme.create();

  /// Builds the complete Dark Theme.
  static ThemeData dark() => AppDarkTheme.create();
}

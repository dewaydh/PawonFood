import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_text_styles.dart';

/// Complete Dark Theme builder for PawonFood.
/// Implements Material 3 with the exact Section 3 dark tokens.
abstract final class AppDarkTheme {
  static ThemeData create() {
    const tokens = AppThemeColors.dark;

    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: tokens.brandPrimary,
      onPrimary: tokens.textInverse,
      primaryContainer: tokens.backgroundTertiary,
      onPrimaryContainer: tokens.textPrimary,
      secondary: tokens.brandSecondary,
      onSecondary: tokens.textInverse,
      secondaryContainer: tokens.backgroundSecondary,
      onSecondaryContainer: tokens.textPrimary,
      tertiary: tokens.brandWarmAccent,
      onTertiary: tokens.textPrimary,
      surface: tokens.surfaceCard,
      onSurface: tokens.textPrimary,
      onSurfaceVariant: tokens.textSecondary,
      outline: tokens.borderDefault,
      outlineVariant: tokens.borderStrong,
      error: tokens.semanticError,
      onError: tokens.backgroundPrimary,
    );

    final textTheme = AppTextStyles.createTextTheme(
      tokens.textPrimary,
      tokens.textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: tokens.backgroundPrimary,
      canvasColor: tokens.backgroundPrimary,
      cardColor: tokens.surfaceCard,
      dividerColor: tokens.borderDivider,
      fontFamily: AppTextStyles.fontBody,
      textTheme: textTheme,
      extensions: const [tokens],

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.backgroundPrimary,
        foregroundColor: tokens.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.h4(tokens.textPrimary),
        iconTheme: IconThemeData(color: tokens.textPrimary),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: tokens.surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: tokens.borderDefault),
        ),
      ),

      // BottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: tokens.surfaceBottomSheet,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        dragHandleColor: tokens.borderStrong,
        dragHandleSize: const Size(40, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: tokens.surfaceModal,
        surfaceTintColor: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: tokens.borderDefault),
        ),
        titleTextStyle: AppTextStyles.h3(tokens.textPrimary),
        contentTextStyle: AppTextStyles.bodyMedium(tokens.textSecondary),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: tokens.surfaceInput,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: AppTextStyles.bodyMedium(tokens.textPlaceholder),
        labelStyle: AppTextStyles.bodyMedium(tokens.textSecondary),
        errorStyle: AppTextStyles.caption(tokens.semanticError),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.borderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.borderFocus, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.semanticError, width: 1.2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: tokens.semanticError, width: 1.5),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: tokens.brandPrimary,
          foregroundColor: tokens.textInverse,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.button(tokens.textInverse),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: tokens.brandPrimary,
          foregroundColor: tokens.textInverse,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: AppTextStyles.button(tokens.textInverse),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: tokens.brandPrimary,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          side: BorderSide(color: tokens.brandPrimary, width: 1.5),
          textStyle: AppTextStyles.button(tokens.brandPrimary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: tokens.brandPrimary,
          minimumSize: const Size(44, 44),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          textStyle: AppTextStyles.button(tokens.brandPrimary),
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: tokens.surfaceInput,
        selectedColor: tokens.brandPrimary,
        disabledColor: tokens.textDisabled.withValues(alpha: 0.15),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: const StadiumBorder(),
        side: BorderSide(color: tokens.borderDefault),
        labelStyle: AppTextStyles.label(tokens.textPrimary),
        secondaryLabelStyle: AppTextStyles.label(tokens.textInverse),
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: tokens.borderDivider,
        thickness: 1,
        space: 1,
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: tokens.surfaceElevated,
        contentTextStyle: AppTextStyles.bodyMedium(tokens.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),

      // Interactive Controls
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) return tokens.textDisabled;
          if (states.contains(WidgetState.selected)) return tokens.textInverse;
          return tokens.textSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled))
            return tokens.borderDefault;
          if (states.contains(WidgetState.selected)) return tokens.brandPrimary;
          return tokens.backgroundSecondary;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tokens.brandPrimary;
          return tokens.borderStrong;
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tokens.brandPrimary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(tokens.textInverse),
        side: BorderSide(color: tokens.borderStrong, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return tokens.brandPrimary;
          return tokens.borderStrong;
        }),
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// Semantic ThemeExtension holding the complete PawonFood design system color tokens.
/// Allows type-safe, theme-aware color consumption via `context.colors.*` or `Theme.of(context).extension<AppThemeColors>()`.
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.backgroundPrimary,
    required this.backgroundSecondary,
    required this.backgroundTertiary,
    required this.surfaceCard,
    required this.surfaceElevated,
    required this.surfaceModal,
    required this.surfaceBottomSheet,
    required this.surfaceInput,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.textPlaceholder,
    required this.textLink,
    required this.textInverse,
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandAccent,
    required this.brandWarmAccent,
    required this.borderDefault,
    required this.borderStrong,
    required this.borderDivider,
    required this.borderFocus,
    required this.semanticSuccess,
    required this.semanticWarning,
    required this.semanticError,
    required this.semanticInfo,
    required this.qrBackground,
    required this.qrForeground,
    required this.shadow,
  });

  // Background
  final Color backgroundPrimary;
  final Color backgroundSecondary;
  final Color backgroundTertiary;

  // Surface
  final Color surfaceCard;
  final Color surfaceElevated;
  final Color surfaceModal;
  final Color surfaceBottomSheet;
  final Color surfaceInput;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color textPlaceholder;
  final Color textLink;
  final Color textInverse;

  // Brand
  final Color brandPrimary;
  final Color brandSecondary;
  final Color brandAccent;
  final Color brandWarmAccent;

  // Borders
  final Color borderDefault;
  final Color borderStrong;
  final Color borderDivider;
  final Color borderFocus;

  // Semantic Status
  final Color semanticSuccess;
  final Color semanticWarning;
  final Color semanticError;
  final Color semanticInfo;

  // Special Components
  final Color qrBackground;
  final Color qrForeground;
  final Color shadow;

  /// Light theme design system tokens
  static const light = AppThemeColors(
    backgroundPrimary: Color(0xFFF8F9F5),
    backgroundSecondary: Color(0xFFF0F2EC),
    backgroundTertiary: Color(0xFFE8ECE4),
    surfaceCard: Color(0xFFFFFFFF),
    surfaceElevated: Color(0xFFFFFFFF),
    surfaceModal: Color(0xFFFFFFFF),
    surfaceBottomSheet: Color(0xFFFFFFFF),
    surfaceInput: Color(0xFFF0F2EC),
    textPrimary: Color(0xFF20251F),
    textSecondary: Color(0xFF626B60),
    textTertiary: Color(0xFF7C8579),
    textDisabled: Color(0xFFA5ACA1),
    textPlaceholder: Color(0xFF858E82),
    textLink: Color(0xFF246B16),
    textInverse: Color(0xFFFFFFFF),
    brandPrimary: Color(0xFF2A7C13),
    brandSecondary: Color(0xFF76C457),
    brandAccent: Color(0xFFFFF8CF),
    brandWarmAccent: Color(0xFFFBE6C2),
    borderDefault: Color(0xFFE1E6DC),
    borderStrong: Color(0xFFC8D0C3),
    borderDivider: Color(0xFFE8ECE4),
    borderFocus: Color(0xFF2A7C13),
    semanticSuccess: Color(0xFF217A3C),
    semanticWarning: Color(0xFF956000),
    semanticError: Color(0xFFC62828),
    semanticInfo: Color(0xFF1769AA),
    qrBackground: Color(0xFFFFFFFF),
    qrForeground: Color(0xFF101710),
    shadow: Color(0x1420251F),
  );

  /// Dark theme design system tokens
  static const dark = AppThemeColors(
    backgroundPrimary: Color(0xFF101710),
    backgroundSecondary: Color(0xFF151E16),
    backgroundTertiary: Color(0xFF202B21),
    surfaceCard: Color(0xFF1C281D),
    surfaceElevated: Color(0xFF263327),
    surfaceModal: Color(0xFF202C21),
    surfaceBottomSheet: Color(0xFF1C281D),
    surfaceInput: Color(0xFF202B21),
    textPrimary: Color(0xFFF1F5EE),
    textSecondary: Color(0xFFB6C1B2),
    textTertiary: Color(0xFF929E90),
    textDisabled: Color(0xFF667263),
    textPlaceholder: Color(0xFF899587),
    textLink: Color(0xFF9BD47F),
    textInverse: Color(0xFF10200C),
    brandPrimary: Color(0xFF76C457),
    brandSecondary: Color(0xFFA4D58C),
    brandAccent: Color(0xFF3A3925),
    brandWarmAccent: Color(0xFF403323),
    borderDefault: Color(0xFF344235),
    borderStrong: Color(0xFF536451),
    borderDivider: Color(0xFF2B382C),
    borderFocus: Color(0xFF76C457),
    semanticSuccess: Color(0xFF72D68B),
    semanticWarning: Color(0xFFF4C56A),
    semanticError: Color(0xFFF16C6C),
    semanticInfo: Color(0xFF75B9F3),
    qrBackground: Color(0xFFFFFFFF),
    qrForeground: Color(0xFF101710),
    shadow: Color(0x40000000),
  );

  @override
  AppThemeColors copyWith({
    Color? backgroundPrimary,
    Color? backgroundSecondary,
    Color? backgroundTertiary,
    Color? surfaceCard,
    Color? surfaceElevated,
    Color? surfaceModal,
    Color? surfaceBottomSheet,
    Color? surfaceInput,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? textPlaceholder,
    Color? textLink,
    Color? textInverse,
    Color? brandPrimary,
    Color? brandSecondary,
    Color? brandAccent,
    Color? brandWarmAccent,
    Color? borderDefault,
    Color? borderStrong,
    Color? borderDivider,
    Color? borderFocus,
    Color? semanticSuccess,
    Color? semanticWarning,
    Color? semanticError,
    Color? semanticInfo,
    Color? qrBackground,
    Color? qrForeground,
    Color? shadow,
  }) =>
      AppThemeColors(
        backgroundPrimary: backgroundPrimary ?? this.backgroundPrimary,
        backgroundSecondary: backgroundSecondary ?? this.backgroundSecondary,
        backgroundTertiary: backgroundTertiary ?? this.backgroundTertiary,
        surfaceCard: surfaceCard ?? this.surfaceCard,
        surfaceElevated: surfaceElevated ?? this.surfaceElevated,
        surfaceModal: surfaceModal ?? this.surfaceModal,
        surfaceBottomSheet: surfaceBottomSheet ?? this.surfaceBottomSheet,
        surfaceInput: surfaceInput ?? this.surfaceInput,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        textTertiary: textTertiary ?? this.textTertiary,
        textDisabled: textDisabled ?? this.textDisabled,
        textPlaceholder: textPlaceholder ?? this.textPlaceholder,
        textLink: textLink ?? this.textLink,
        textInverse: textInverse ?? this.textInverse,
        brandPrimary: brandPrimary ?? this.brandPrimary,
        brandSecondary: brandSecondary ?? this.brandSecondary,
        brandAccent: brandAccent ?? this.brandAccent,
        brandWarmAccent: brandWarmAccent ?? this.brandWarmAccent,
        borderDefault: borderDefault ?? this.borderDefault,
        borderStrong: borderStrong ?? this.borderStrong,
        borderDivider: borderDivider ?? this.borderDivider,
        borderFocus: borderFocus ?? this.borderFocus,
        semanticSuccess: semanticSuccess ?? this.semanticSuccess,
        semanticWarning: semanticWarning ?? this.semanticWarning,
        semanticError: semanticError ?? this.semanticError,
        semanticInfo: semanticInfo ?? this.semanticInfo,
        qrBackground: qrBackground ?? this.qrBackground,
        qrForeground: qrForeground ?? this.qrForeground,
        shadow: shadow ?? this.shadow,
      );

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      backgroundPrimary: Color.lerp(backgroundPrimary, other.backgroundPrimary, t)!,
      backgroundSecondary: Color.lerp(backgroundSecondary, other.backgroundSecondary, t)!,
      backgroundTertiary: Color.lerp(backgroundTertiary, other.backgroundTertiary, t)!,
      surfaceCard: Color.lerp(surfaceCard, other.surfaceCard, t)!,
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      surfaceModal: Color.lerp(surfaceModal, other.surfaceModal, t)!,
      surfaceBottomSheet: Color.lerp(surfaceBottomSheet, other.surfaceBottomSheet, t)!,
      surfaceInput: Color.lerp(surfaceInput, other.surfaceInput, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      brandPrimary: Color.lerp(brandPrimary, other.brandPrimary, t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandAccent: Color.lerp(brandAccent, other.brandAccent, t)!,
      brandWarmAccent: Color.lerp(brandWarmAccent, other.brandWarmAccent, t)!,
      borderDefault: Color.lerp(borderDefault, other.borderDefault, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      borderDivider: Color.lerp(borderDivider, other.borderDivider, t)!,
      borderFocus: Color.lerp(borderFocus, other.borderFocus, t)!,
      semanticSuccess: Color.lerp(semanticSuccess, other.semanticSuccess, t)!,
      semanticWarning: Color.lerp(semanticWarning, other.semanticWarning, t)!,
      semanticError: Color.lerp(semanticError, other.semanticError, t)!,
      semanticInfo: Color.lerp(semanticInfo, other.semanticInfo, t)!,
      qrBackground: Color.lerp(qrBackground, other.qrBackground, t)!,
      qrForeground: Color.lerp(qrForeground, other.qrForeground, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

/// Central Color Tokens and Adaptive Accessors.
/// Combines compile-time constants for backward compatibility with dynamic theme adaptation.
abstract final class AppColors {
  /// Global theme state tracker, synchronized on every rebuild in `app.dart`.
  static bool isDark = false;

  // ── Backward-Compatible Light Constants ─────────────────────────────────────
  static const primary = Color(0xFF2A7C13);
  static const primaryDark = Color(0xFF1E5B0D);
  static const ink = Color(0xFF20251F);
  static const inkMuted = Color(0xFF626B60);
  static const background = Color(0xFFF8F9F5);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceSand = Color(0xFFF0F2EC);
  static const mapSand = Color(0xFFE8ECE4);
  static const border = Color(0xFFE1E6DC);
  static const borderStrong = Color(0xFFC8D0C3);
  static const accent = Color(0xFFB15732);
  static const accentInk = Color(0xFF6F2B18);
  static const successTint = Color(0xFFE8ECE4);
  static const cameraBg = Color(0xFF101710);
  static const foodWarm = Color(0xFFC18A52);
  static const foodGreen = Color(0xFFA8B46A);
  static const error = Color(0xFFC62828);

  // Sampled from hi-fi mockups
  static const mapRoad = Color(0xFFF0F2EC);
  static const mapBlock = Color(0xFFE8ECE4);
  static const mapPark = Color(0xFFDDE6D7);
  static const avatarOlive = Color(0xFF5E752F);
  static const avatarTaupe = Color(0xFF796B4E);
  static const cameraControl = Color(0xFF202B21);
  static const cameraLine = Color(0xFF2A392C);
  static const detectBox = Color(0xFFCFE3D0);
  static const onGreenMuted = Color(0xFFCFE0D2);
  static const onGreenTrack = Color(0xFF5A8263);
  static const errorLight = Color(0xFFF2B8B5);
  static const cameraText = Color(0xFFD9D3C2);

  // Scrims
  static const scrimClear = Color(0x00101710);
  static const scrimDim = Color(0x2E101710);
  static const scrimTop = Color(0x73101710);
  static const scrimLabel = Color(0xC7101710);
  static const scrimBottom = Color(0xE6101710);

  // Shadows
  static const shadow = Color(0x1420251F);
  static const darkShadow = Color(0x40000000);

  // ── Adaptive Accessors (Theme-Aware) ────────────────────────────────────────

  /// Returns current AppThemeColors extension from context, or light/dark based on global tracker.
  static AppThemeColors of([BuildContext? context]) {
    if (context != null) {
      final ext = Theme.of(context).extension<AppThemeColors>();
      if (ext != null) return ext;
      return Theme.of(context).brightness == Brightness.dark
          ? AppThemeColors.dark
          : AppThemeColors.light;
    }
    return isDark ? AppThemeColors.dark : AppThemeColors.light;
  }

  static Color surfaceOf([BuildContext? context]) => of(context).surfaceCard;
  static Color surfaceElevatedOf([BuildContext? context]) => of(context).surfaceElevated;
  static Color surfaceInputOf([BuildContext? context]) => of(context).surfaceInput;
  static Color backgroundOf([BuildContext? context]) => of(context).backgroundPrimary;
  static Color backgroundSecondaryOf([BuildContext? context]) => of(context).backgroundSecondary;
  static Color backgroundTertiaryOf([BuildContext? context]) => of(context).backgroundTertiary;
  static Color inkOf([BuildContext? context]) => of(context).textPrimary;
  static Color inkMutedOf([BuildContext? context]) => of(context).textSecondary;
  static Color inkTertiaryOf([BuildContext? context]) => of(context).textTertiary;
  static Color disabledOf([BuildContext? context]) => of(context).textDisabled;
  static Color placeholderOf([BuildContext? context]) => of(context).textPlaceholder;
  static Color linkOf([BuildContext? context]) => of(context).textLink;
  static Color inverseOf([BuildContext? context]) => of(context).textInverse;
  static Color borderOf([BuildContext? context]) => of(context).borderDefault;
  static Color borderStrongOf([BuildContext? context]) => of(context).borderStrong;
  static Color dividerOf([BuildContext? context]) => of(context).borderDivider;
  static Color focusOf([BuildContext? context]) => of(context).borderFocus;
  static Color sandOf([BuildContext? context]) => of(context).backgroundSecondary;
  static Color primaryOf([BuildContext? context]) => of(context).brandPrimary;
  static Color secondaryOf([BuildContext? context]) => of(context).brandSecondary;
  static Color accentOf([BuildContext? context]) => of(context).brandAccent;
  static Color warmAccentOf([BuildContext? context]) => of(context).brandWarmAccent;
  static Color successOf([BuildContext? context]) => of(context).semanticSuccess;
  static Color warningOf([BuildContext? context]) => of(context).semanticWarning;
  static Color errorOf([BuildContext? context]) => of(context).semanticError;
  static Color infoOf([BuildContext? context]) => of(context).semanticInfo;
  static Color successTintOf([BuildContext? context]) => of(context).backgroundTertiary;
  static Color shadowOf([BuildContext? context]) => of(context).shadow;

  // QR Code colors: always high contrast dark on pure white across both themes
  static const qrBg = Color(0xFFFFFFFF);
  static const qrFg = Color(0xFF101710);
}

/// Convenience extension on BuildContext to access theme colors and styles cleanly.
extension BuildContextThemeX on BuildContext {
  AppThemeColors get colors => AppColors.of(this);
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}

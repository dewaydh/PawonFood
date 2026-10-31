import 'package:flutter/material.dart';

import '../motion/entrance.dart';
import '../motion/pressable.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum AppButtonVariant { primary, outline, accent, ghost, light, danger }

/// Buttons from DESIGN_SYSTEM.md & Theme System:
/// Supports primary, outline, accent, ghost, light and danger (destructive).
/// 16px corner radius, 52–56px height, responsive to Light & Dark themes.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.leading,
    this.height = 54,
    this.loading = false,
    this.expand = true,
    this.textSize = 15,
    this.iconOnly = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;

  /// Custom widget before the label (e.g. brand logo).
  final Widget? leading;
  final double height;
  final bool loading;
  final bool expand;
  final double textSize;

  /// Shows only [icon]; [label] remains accessible name.
  final bool iconOnly;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = context.isDark;
    final enabled = onPressed != null && !loading;

    final (Color bg, Color fg, Color? border) = !enabled && !loading
        ? (colors.surfaceInput, colors.textDisabled, null)
        : switch (variant) {
            AppButtonVariant.primary => (
                colors.brandPrimary,
                colors.textInverse,
                null,
              ),
            AppButtonVariant.outline => (
                colors.surfaceCard,
                colors.brandPrimary,
                colors.brandPrimary,
              ),
            AppButtonVariant.accent => (
                colors.surfaceCard,
                isDark ? const Color(0xFFFFB499) : const Color(0xFF6F2B18),
                isDark ? const Color(0xFFE07A52) : const Color(0xFFB15732),
              ),
            AppButtonVariant.ghost => (
                colors.backgroundSecondary,
                colors.textPrimary,
                null,
              ),
            AppButtonVariant.light => (
                colors.backgroundPrimary,
                colors.textPrimary,
                null,
              ),
            AppButtonVariant.danger => (
                colors.semanticError,
                colors.textInverse,
                null,
              ),
          };

    final Widget content = loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.5, color: fg),
          )
        : iconOnly && icon != null
            ? Icon(icon, size: 22, color: fg)
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 8),
                  ] else if (icon != null) ...[
                    Icon(icon, size: 20, color: fg),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.button(fg).copyWith(fontSize: textSize),
                    ),
                  ),
                ],
              );

    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Pressable(
        enabled: enabled,
        child: SizedBox(
          width: expand ? double.infinity : null,
          height: height,
          child: Material(
            color: bg,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: border == null ? BorderSide.none : BorderSide(color: border, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: enabled ? onPressed : null,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: FadeSwitch(
                    alignment: Alignment.center,
                    child: KeyedSubtree(key: ValueKey(loading), child: content),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'navigation_widgets.dart';

/// Back button (circle), centred title and an optional action (DESIGN_SYSTEM.md -> Top bar).
/// Theme-aware: adapts seamlessly to dark mode without glaring white controls.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    this.title,
    this.fallback = '/',
    this.onBack,
    this.action,
    this.close = false,
    this.dark = false,
    this.onTitleLongPress,
  });

  final String? title;
  final String fallback;
  final VoidCallback? onBack;
  final Widget? action;

  /// Shows an X instead of the arrow (full-screen tasks such as the scanner).
  final bool close;

  /// For full-screen camera/scanner views with dark scrim overlays.
  final bool dark;

  /// Hidden demo switch (like the camera's AI mode).
  final VoidCallback? onTitleLongPress;

  @override
  Widget build(BuildContext context) {
    final effectiveFill = dark ? AppColors.cameraControl : AppColors.surfaceOf(context);
    final effectiveBorder = dark ? null : AppColors.borderOf(context);
    final effectiveIconColor = dark ? const Color(0xFFFAF6ED) : AppColors.inkOf(context);
    final effectiveTitleColor = dark ? const Color(0xFFFAF6ED) : AppColors.inkOf(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(children: [
        RoundIconButton(
          icon: close ? LucideIcons.x : LucideIcons.arrowLeft,
          semanticLabel: close ? 'Tutup' : 'Kembali',
          fill: effectiveFill,
          borderColor: effectiveBorder,
          iconColor: effectiveIconColor,
          onTap: onBack ?? () => context.canPop() ? context.pop() : context.go(fallback),
        ),
        Expanded(
          child: GestureDetector(
            onLongPress: onTitleLongPress,
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: AppTypography.display(
                17.5,
                weight: 700,
                color: effectiveTitleColor,
              ),
            ),
          ),
        ),
        SizedBox(width: 44, child: action),
      ]),
    );
  }
}

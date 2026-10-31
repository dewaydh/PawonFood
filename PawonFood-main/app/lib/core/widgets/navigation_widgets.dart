import 'package:flutter/material.dart';

import '../motion/pressable.dart';
import '../theme/app_colors.dart';

// Re-export everything from the curved navigation implementation so that
// existing imports of navigation_widgets.dart still resolve navBarHeight,
// navFabRise, navContentInset, and PawonBottomNav (alias of CurvedBottomNav).
export 'curved_bottom_nav.dart';

/// Circular 44pt icon button (back, close, flash, locate...).
/// Theme-aware: adapts default surface & border to dark mode automatically.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    this.icon,
    this.iconWidget,
    required this.onTap,
    required this.semanticLabel,
    this.fill,
    this.borderColor,
    this.iconColor,
    this.size = 44,
    this.shadow = false,
  }) : assert(
         (icon == null) != (iconWidget == null),
         'Give either icon or iconWidget',
       );

  final IconData? icon;
  final Widget? iconWidget;
  final VoidCallback? onTap;
  final String semanticLabel;
  final Color? fill;
  final Color? borderColor;
  final Color? iconColor;
  final double size;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final effectiveFill = fill ?? AppColors.surfaceOf(context);
    final effectiveBorder = borderColor ?? AppColors.borderOf(context);
    final effectiveIconColor = iconColor ?? AppColors.inkOf(context);

    return Semantics(
      button: true,
      label: semanticLabel,
      child: Pressable(
        enabled: onTap != null,
        scale: 0.92,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: shadow
                ? [
                    BoxShadow(
                      color: AppColors.shadowOf(context),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Material(
            color: effectiveFill,
            shape: CircleBorder(side: BorderSide(color: effectiveBorder)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                width: size,
                height: size,
                child: Center(
                  child:
                      iconWidget ??
                      Icon(icon, size: 24, color: effectiveIconColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Langkah N dari 3" progress: 3 segments, green when done, sand when pending.
class StepProgress extends StatelessWidget {
  const StepProgress({
    super.key,
    required this.current,
    this.total = 3,
    this.dark = false,
  });

  final int current;
  final int total;
  final bool dark;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Langkah $current dari $total',
    child: Row(
      children: [
        for (var i = 0; i < total; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: i < current
                    ? (dark ? AppColors.background : AppColors.primary)
                    : (dark
                          ? AppColors.cameraLine
                          : AppColors.borderOf(context)),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ],
      ],
    ),
  );
}

// PawonBottomNav is now provided by curved_bottom_nav.dart (re-exported above).

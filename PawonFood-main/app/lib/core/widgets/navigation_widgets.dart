import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../motion/motion.dart';
import '../motion/pressable.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'brand.dart';
import 'brush_decorations.dart';

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
  }) : assert((icon == null) != (iconWidget == null), 'Give either icon or iconWidget');

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
                    )
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
                  child: iconWidget ?? Icon(icon, size: 24, color: effectiveIconColor),
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
  const StepProgress({super.key, required this.current, this.total = 3, this.dark = false});

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
                        : (dark ? AppColors.cameraLine : AppColors.borderOf(context)),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}

/// Height of the bar above the system gesture inset.
const double navBarHeight = 68;
const double _fabRise = 30;

/// How far the raised Bagikan button sticks out above the bar.
const double navFabRise = _fabRise;

/// Bottom space a tab screen should leave so content is not hidden behind the nav bar.
double navContentInset(BuildContext context) => navBarHeight + MediaQuery.paddingOf(context).bottom + 16;

/// Bottom navigation: Beranda, Peta, **Bagikan** (hand-crafted artisanal hearth seal), Pesan, Profil.
/// Designed according to anti-slop principles:
/// - Minimalist yet warm, with subtle cartoon brush active stroke.
/// - The center "Bagikan" action is an authentic traditional kitchen seal, not a generic FAB.
/// - Full adaptive theme support (zero blinding white in Dark Mode).
class PawonBottomNav extends StatelessWidget {
  const PawonBottomNav({super.key, required this.currentIndex, required this.onTap, required this.onShare});

  /// Index among the four tabs: 0 Beranda, 1 Peta, 2 Pesan, 3 Profil.
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onShare;

  static const _items = [
    (LucideIcons.house, 'Beranda'),
    (LucideIcons.mapPin, 'Peta'),
    (LucideIcons.messageSquare, 'Pesan'),
    (LucideIcons.userRound, 'Profil'),
  ];

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.paddingOf(context).bottom;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget item(int i) {
      final (icon, label) = _items[i];
      final on = i == currentIndex;
      final iconColor = on ? primaryColor : AppColors.inkMutedOf(context);

      return Expanded(
        child: Semantics(
          button: true,
          selected: on,
          label: label,
          child: InkResponse(
            onTap: () => onTap(i),
            radius: 38,
            highlightShape: BoxShape.circle,
            child: SizedBox(
              height: navBarHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Active icon with scale transition
                  AnimatedScale(
                    scale: on ? 1.08 : 0.95,
                    duration: Motion.of(context, Motion.base),
                    curve: Curves.easeOutBack,
                    child: Icon(icon, size: 24, color: iconColor),
                  ),
                  const SizedBox(height: 3),
                  // Artisanal label with brush indicator
                  MediaQuery.withClampedTextScaling(
                    maxScaleFactor: 1.25,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          style: AppTypography.labelExpressive(
                            11.5,
                            weight: on ? 800 : 500,
                            color: on ? primaryColor : AppColors.inkMutedOf(context),
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Hand-drawn brush active underline
                        AnimatedOpacity(
                          opacity: on ? 1.0 : 0.0,
                          duration: Motion.of(context, Motion.base),
                          child: AnimatedContainer(
                            duration: Motion.of(context, Motion.base),
                            curve: Curves.easeOutCubic,
                            height: 2.5,
                            width: on ? 18 : 0,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: navBarHeight + inset + _fabRise,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── The Nav Dock Bar ───────────────────────────────────────────────
          Positioned(
            top: _fabRise,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                border: Border(top: BorderSide(color: borderColor, width: 1.0)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowOf(context),
                    blurRadius: 14,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              padding: EdgeInsets.only(bottom: inset),
              child: Row(children: [
                item(0),
                item(1),
                // Center slot for Bagikan
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 36),
                    child: ExcludeSemantics(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MediaQuery.withClampedTextScaling(
                            maxScaleFactor: 1.2,
                            child: Text(
                              'Bagikan',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              style: AppTypography.labelExpressive(
                                11.5,
                                weight: 800,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Container(
                            height: 2.5,
                            width: 14,
                            decoration: BoxDecoration(
                              color: AppColors.accentOf(context).withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                item(2),
                item(3),
              ]),
            ),
          ),

          // ── Hand-crafted Hearth Center Action ─────────────────────────────
          Positioned(
            top: 2,
            left: 0,
            right: 0,
            child: Center(
              child: Semantics(
                button: true,
                label: 'Bagikan makanan',
                child: GestureDetector(
                  onTap: onShare,
                  child: Pressable(
                    scale: 0.92,
                    child: Container(
                      width: 66,
                      height: 66,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: surfaceColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppColors.borderStrongOf(context) : AppColors.surfaceSand,
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withValues(alpha: 0.28),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: AppColors.shadowOf(context),
                            blurRadius: 6,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Container(
                        width: 52,
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              primaryColor,
                              isDark ? const Color(0xFF2E5E3A) : AppColors.primaryDark,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            const PawonLogo(size: 28, color: Color(0xFFFAF6ED)),
                            // Subtle cartoon steam hint above logo
                            const Positioned(
                              top: 4,
                              child: CartoonSteam(width: 16, height: 10, color: Color(0x60FAF6ED)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

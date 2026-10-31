import 'package:flutter/material.dart';

import '../motion/motion.dart';
import '../motion/pressable.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Filter chip: filled green when selected, adaptive surface with a subtle border otherwise.
/// Styled with expressive typography and full Dark Mode support.
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.height = 38,
    this.accentWhenUnselected = false,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final double height;

  /// Terracotta outline (used for the "Tawar lagi" quick reply).
  final bool accentWhenUnselected;

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final inkColor = AppColors.inkOf(context);

    final border = selected
        ? primaryColor
        : (accentWhenUnselected ? AppColors.accentOf(context) : borderColor);

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Pressable(
        enabled: onTap != null,
        child: AnimatedContainer(
          duration: Motion.of(context, Motion.base),
          curve: Motion.move,
          decoration: ShapeDecoration(
            color: selected ? primaryColor : surfaceColor,
            shape: StadiumBorder(
              side: BorderSide(
                color: border,
                width: accentWhenUnselected && !selected ? 1.5 : 1.1,
              ),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: onTap,
              child: Container(
                height: height,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  widthFactor: 1,
                  child: AnimatedDefaultTextStyle(
                    duration: Motion.of(context, Motion.base),
                    style: AppTypography.labelExpressive(
                      13.5,
                      weight: selected ? 800 : 600,
                      color: selected
                          ? const Color(0xFFFAF6ED)
                          : (accentWhenUnselected ? AppColors.accentOf(context) : inkColor),
                    ),
                    child: Text(label),
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

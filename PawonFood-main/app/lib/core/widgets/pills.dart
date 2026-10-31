import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/conversation.dart';
import '../models/enums.dart';
import '../motion/motion_widgets.dart';
import '../services/food_label.dart';
import '../services/formatters.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Generic rounded pill. Badges, distance, points and status are presets below.
/// Theme-aware: adapts default fills, inks, and borders dynamically.
class Pill extends StatelessWidget {
  const Pill(
    this.label, {
    super.key,
    this.fill,
    this.color,
    this.border,
    this.icon,
    this.iconColor,
    this.height = 28,
    this.size = 12,
    this.weight = 600,
    this.hPad = 12,
  });

  final String label;
  final Color? fill;
  final Color? color;
  final Color? border;
  final IconData? icon;
  final Color? iconColor;
  final double height;
  final double size;
  final double weight;
  final double hPad;

  @override
  Widget build(BuildContext context) {
    final effectiveFill = fill ?? AppColors.sandOf(context);
    final effectiveColor = color ?? AppColors.inkOf(context);

    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: hPad),
      decoration: BoxDecoration(
        color: effectiveFill,
        borderRadius: BorderRadius.circular(999),
        border: border == null ? null : Border.all(color: border!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: size + 3, color: iconColor ?? effectiveColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            maxLines: 1,
            style: AppTypography.labelExpressive(size, weight: weight, color: effectiveColor),
          ),
        ],
      ),
    );
  }
}

/// Status label on food photos: Populer / Terbaru / Hampir habis.
class FoodLabelBadge extends StatelessWidget {
  const FoodLabelBadge(this.label, {super.key});

  final FoodLabel label;

  @override
  Widget build(BuildContext context) => Pill(
        label.label,
        fill: AppColors.surfaceOf(context),
        color: AppColors.inkOf(context),
        height: 24,
        weight: 700,
        hPad: 8,
      );
}

/// Terracotta "Sisa N porsi" badge.
class StockBadge extends StatelessWidget {
  const StockBadge(this.portions, {super.key, this.height = 24, this.size = 12});

  final int portions;
  final double height;
  final double size;

  @override
  Widget build(BuildContext context) => Pill(
        'Sisa $portions porsi',
        fill: AppColors.accentOf(context),
        color: const Color(0xFFFAF6ED),
        height: height,
        size: size,
        weight: 700,
        hPad: 8,
      );
}

/// Small label on a success tint (tier names, reward category, validity).
class InfoTag extends StatelessWidget {
  const InfoTag(this.label, {super.key, this.height = 24, this.size = 12});

  final String label;
  final double height;
  final double size;

  @override
  Widget build(BuildContext context) => IntrinsicWidth(
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.successTintOf(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: AppTypography.labelExpressive(
              size,
              weight: 700,
              color: AppColors.primaryOf(context),
            ),
          ),
        ),
      );
}

/// Tier tag (Pawon Friend / Pawon Elite / Pawon Hero).
class TierTag extends InfoTag {
  TierTag(Tier tier, {super.key, super.height, super.size}) : super(tier.label);
}

/// "Bisa diantar" on a food card, next to the tier tag.
class DeliveryTag extends StatelessWidget {
  const DeliveryTag({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
        label: 'Bisa diantar',
        child: Container(
          height: 24,
          width: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.successTintOf(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(LucideIcons.bike, size: 14, color: AppColors.primaryOf(context)),
        ),
      );
}

/// "Bawa wadah sendiri" on a food card, next to the tier tag.
class ContainerTag extends StatelessWidget {
  const ContainerTag({super.key});

  @override
  Widget build(BuildContext context) => Semantics(
        label: Packaging.wadahSendiri.label,
        child: Container(
          height: 24,
          width: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.sandOf(context),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(LucideIcons.container, size: 14, color: AppColors.accentOf(context)),
        ),
      );
}

class DistancePill extends StatelessWidget {
  const DistancePill(this.meters, {super.key});

  final double meters;

  @override
  Widget build(BuildContext context) => Pill(
        formatDistance(meters),
        size: 11.5,
        hPad: 10,
        fill: AppColors.sandOf(context),
        color: AppColors.inkMutedOf(context),
      );
}

class PointsPill extends StatelessWidget {
  const PointsPill(this.points, {super.key});

  final int points;

  @override
  Widget build(BuildContext context) {
    final sandColor = AppColors.sandOf(context);
    final accentColor = AppColors.accentOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: sandColor,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderOf(context), width: 1.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.coins, size: 18, color: accentColor),
          const SizedBox(width: 6),
          AnimatedCount(
            value: points,
            format: (v) => '${v.round()} Poin',
            style: AppTypography.labelExpressive(
              14,
              weight: 800,
              color: isDark ? const Color(0xFFFFB499) : AppColors.accentInk,
            ),
          ),
        ],
      ),
    );
  }
}

/// Status label on a thread row: Tawaran diterima / Siap diambil / Habis.
class StatusPill extends StatelessWidget {
  const StatusPill(this.status, {super.key});

  final ThreadStatus status;

  @override
  Widget build(BuildContext context) {
    final muted = status == ThreadStatus.soldOut || status == ThreadStatus.waiting;
    return Pill(
      status.label,
      fill: muted ? AppColors.sandOf(context) : AppColors.successTintOf(context),
      color: muted ? AppColors.inkMutedOf(context) : AppColors.primaryOf(context),
      hPad: 10,
    );
  }
}

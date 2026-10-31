import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../models/listing.dart';
import '../motion/pressable.dart';
import '../services/food_label.dart';
import '../services/formatters.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'brush_decorations.dart';
import 'listing_photo.dart';
import 'pills.dart';

/// Struck-through original price, adapts to theme brightness.
TextStyle struckStyle(BuildContext context, double size) =>
    AppTypography.text(size, color: AppColors.inkMutedOf(context)).copyWith(
      decoration: TextDecoration.lineThrough,
      decorationColor: AppColors.inkMutedOf(context),
    );

/// Price in the bottom-right corner of a card:
/// Free food shows an artisanal green GRATIS stamp. Paid food shows clear rupiah price.
class CardPrice extends StatelessWidget {
  const CardPrice(this.listing, {super.key, this.priceSize = 20});

  final Listing listing;
  final double priceSize;

  @override
  Widget build(BuildContext context) {
    final l = listing;
    final primaryColor = AppColors.primaryOf(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!l.isFree && l.originalPrice != null)
          Text(formatRupiah(l.originalPrice!), style: struckStyle(context, 12)),
        if (l.isFree)
          const CartoonStampBadge(label: 'GRATIS', isGratis: true, size: 12)
        else
          Text(
            formatRupiah(l.price),
            style: AppTypography.display(
              priceSize,
              weight: 800,
              color: AppColors.inkOf(context),
            ),
          ),
      ],
    );
  }
}

/// Food card (DESIGN_SYSTEM.md):
/// Photo with artisanal cartoon stamp labels ("Sisa N porsi", "Hangat"), title, provider,
/// distance pill and clear price.
/// Fully theme-adaptive: clean white in light, rich kitchen slate in dark.
class FoodCard extends ConsumerWidget {
  const FoodCard({super.key, required this.listing, required this.distance, required this.onTap});

  final Listing listing;
  final double distance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = listing;
    final label = foodLabelFor(l, ref.watch(clockProvider)());
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return Semantics(
      button: true,
      label:
          '${l.name}${label == null ? '' : ', ${label.label.toLowerCase()}'}, ${l.provider.name}, ${l.isFree ? 'gratis' : formatRupiah(l.price)}${l.negotiable ? ', bisa ditawar' : ''}${l.canDeliver ? ', bisa diantar' : ''}${l.bringsContainer ? ', bawa wadah sendiri' : ''}, sisa ${l.portionsLeft} porsi, ${formatDistance(distance)}',
      child: Pressable(
        scale: 0.98,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: l.isFree
                    ? primaryColor.withValues(alpha: 0.12)
                    : AppColors.shadowOf(context),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Material(
            color: surfaceColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: l.isFree ? primaryColor.withValues(alpha: 0.35) : borderColor,
                width: l.isFree ? 1.4 : 1.0,
              ),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: SizedBox(
                height: math.max(134, 42 * textScaleOf(context) + 92),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Photo with organic badges
                      SizedBox(
                        width: 104,
                        height: 104,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: ListingPhoto(l, width: 104, height: 104, radius: 14),
                            ),
                            if (label != null)
                              Positioned(top: 6, right: 6, child: FoodLabelBadge(label)),
                            Positioned(
                              bottom: 6,
                              left: 6,
                              child: CartoonStampBadge(
                                label: 'Sisa ${l.portionsLeft}',
                                isUrgent: l.portionsLeft <= 2,
                                size: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.display(
                                      16,
                                      weight: 700,
                                      height: 22,
                                      color: AppColors.inkOf(context),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    l.provider.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.text(
                                      13.5,
                                      height: 18,
                                      color: AppColors.inkMutedOf(context),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Row(children: [
                                    TierTag(l.provider.tier),
                                    if (l.canDeliver) ...[const SizedBox(width: 6), const DeliveryTag()],
                                    if (l.bringsContainer) ...[const SizedBox(width: 6), const ContainerTag()],
                                  ]),
                                ],
                              ),
                            ),
                            Positioned(left: 0, bottom: 0, child: DistancePill(distance)),
                            Positioned(right: 0, bottom: 0, child: CardPrice(l)),
                          ],
                        ),
                      ),
                    ],
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

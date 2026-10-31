import 'package:flutter/material.dart';

import '../services/formatters.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'food_card.dart';
import 'pills.dart';

/// Bordered tile with a label, a value and a caption (Jarak / Ambil sebelum / Kategori).
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, required this.caption});

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
      decoration: BoxDecoration(
        color: colors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.caption(colors.textSecondary)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(value, maxLines: 1, style: AppTextStyles.h3(colors.textPrimary)),
          ),
          Text(caption, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.caption(colors.textSecondary)),
        ],
      ),
    );
  }
}

/// Panel with struck-through and current price plus the "Bisa ditawar" pill.
class PriceBox extends StatelessWidget {
  const PriceBox({super.key, required this.price, this.originalPrice, this.negotiable = true});

  final int price;
  final int? originalPrice;
  final bool negotiable;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = context.isDark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: colors.backgroundSecondary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderDefault),
      ),
      child: Row(
        children: [
          Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  if (originalPrice != null && price != 0) ...[
                    Text(formatRupiah(originalPrice!), style: struckStyle(context, 15)),
                    const SizedBox(width: 12),
                  ],
                  Text(
                    price == 0 ? 'GRATIS' : formatRupiah(price),
                    style: AppTextStyles.display(price == 0 ? colors.brandPrimary : colors.textPrimary),
                  ),
                ],
              ),
            ),
          ),
          if (negotiable && price != 0)
            Pill(
              'Bisa ditawar',
              fill: colors.surfaceCard,
              color: isDark ? const Color(0xFFFFB499) : const Color(0xFF6F2B18),
              height: 32,
              size: 13,
              weight: 700,
              hPad: 14,
            ),
        ],
      ),
    );
  }
}

/// Label on the left, amount on the right (payment breakdowns: "Harga disepakati", "Total").
class AmountRow extends StatelessWidget {
  const AmountRow(this.label, this.value, {super.key, this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Expanded(
          child: Text(
            label,
            style: strong ? AppTextStyles.h4(colors.textPrimary) : AppTextStyles.bodyMedium(colors.textSecondary),
          ),
        ),
        Text(
          value,
          style: strong ? AppTextStyles.h4(colors.textPrimary) : AppTextStyles.bodyMedium(colors.textPrimary).copyWith(fontWeight: FontWeight.w700),
        ),
      ]),
    );
  }
}

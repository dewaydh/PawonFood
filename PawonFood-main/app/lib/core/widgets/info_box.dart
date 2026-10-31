import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../models/enums.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum InfoTone {
  /// Sand panel (safety notes, privacy, refunds).
  sand,

  /// Success tint (waiting for an answer, good news).
  tint,

  /// Dark panel (QRIS "belum masuk").
  dark,
}

/// Icon + short note on a soft panel. Used for safety, privacy and status notes across the flows.
class InfoBox extends StatelessWidget {
  const InfoBox(this.text, {super.key, this.icon = LucideIcons.shieldCheck, this.tone = InfoTone.sand, this.title, this.iconColor});

  final String text;
  final String? title;
  final IconData icon;
  final InfoTone tone;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (bg, fg, ic) = switch (tone) {
      InfoTone.sand => (colors.backgroundSecondary, colors.textPrimary, colors.brandPrimary),
      InfoTone.tint => (colors.backgroundTertiary, colors.textPrimary, colors.brandPrimary),
      InfoTone.dark => (colors.surfaceElevated, colors.textPrimary, colors.brandPrimary),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: tone == InfoTone.tint ? Border.all(color: colors.borderDefault) : null,
        boxShadow: tone == InfoTone.dark ? [BoxShadow(color: colors.shadow, blurRadius: 12, offset: const Offset(0, 4))] : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(top: 1), child: Icon(icon, size: 22, color: iconColor ?? ic)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[Text(title!, style: AppTextStyles.h4(fg)), const SizedBox(height: 4)],
                Text(text, style: AppTextStyles.bodyMedium(title != null && tone == InfoTone.tint ? colors.brandPrimary : fg)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "Kemasan" row of the detail and chat cards: wrapped food in the success tint, "Bawa wadah sendiri" in sand with an accent icon.
class PackagingNote extends StatelessWidget {
  const PackagingNote(this.packaging, {super.key, this.compact = false});

  final Packaging packaging;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final wadah = packaging == Packaging.wadahSendiri;
    final icon = wadah ? LucideIcons.container : LucideIcons.package;

    if (compact) {
      return Row(children: [
        Icon(icon, size: 16, color: wadah ? colors.brandWarmAccent : colors.brandPrimary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            wadah ? '${packaging.label} · ${packaging.hint}' : packaging.label,
            style: AppTextStyles.bodySmall(colors.textPrimary).copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ]);
    }

    return InfoBox(
      packaging.hint,
      title: packaging.label,
      icon: icon,
      tone: wadah ? InfoTone.sand : InfoTone.tint,
      iconColor: wadah ? colors.brandWarmAccent : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/data/settings_repository.dart';
import '../../core/motion/entrance.dart';
import '../../core/motion/pressable.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/brush_decorations.dart';
import '../../core/widgets/pills.dart';
import '../../core/widgets/top_bar.dart';

/// Pengaturan Tampilan & Aksesibilitas (Theme, Font Size, Motion & Performance).
/// Fully theme-adaptive, handcrafted minimalist layout.
class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final inkColor = AppColors.inkOf(context);
    final inkMutedColor = AppColors.inkMutedOf(context);

    return Scaffold(
      body: SafeArea(
        child: EntranceScope(
          child: Column(
            children: [
              const TopBar(
                title: 'Tampilan & Aksesibilitas',
                fallback: '/settings',
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  children: [
                    // 1. Live Preview Card
                    FadeSlideIn(
                      index: 0,
                      child: _LivePreviewCard(
                        fontScale: settings.fontScale,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 2. Mode Tema
                    FadeSlideIn(
                      index: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BrushUnderline(
                            color: primaryColor.withValues(alpha: 0.35),
                            offsetY: 2,
                            child: Text(
                              'Tema Aplikasi',
                              style: AppTypography.display(16, weight: 800, color: inkColor),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Pilih nuansa tampilan yang paling nyaman untuk matamu.',
                            style: AppTypography.caption,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _ThemeOptionTile(
                                  label: 'Sistem',
                                  icon: LucideIcons.smartphone,
                                  selected: settings.themeMode == ThemeMode.system,
                                  onTap: () => notifier.setThemeMode(ThemeMode.system),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _ThemeOptionTile(
                                  label: 'Terang',
                                  icon: LucideIcons.sun,
                                  selected: settings.themeMode == ThemeMode.light,
                                  onTap: () => notifier.setThemeMode(ThemeMode.light),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _ThemeOptionTile(
                                  label: 'Gelap',
                                  icon: LucideIcons.moon,
                                  selected: settings.themeMode == ThemeMode.dark,
                                  onTap: () => notifier.setThemeMode(ThemeMode.dark),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 3. Ukuran Teks / Font Scale
                    FadeSlideIn(
                      index: 2,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Ukuran Font',
                                  style: AppTypography.display(16, weight: 800, color: inkColor),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.sandOf(context),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Text(
                                    settings.fontScaleLabel,
                                    style: AppTypography.labelExpressive(
                                      12.5,
                                      weight: 800,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Sesuaikan ukuran teks agar lebih mudah dibaca.',
                              style: AppTypography.caption,
                            ),
                            const SizedBox(height: 12),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: primaryColor,
                                inactiveTrackColor: AppColors.sandOf(context),
                                thumbColor: primaryColor,
                                trackHeight: 6,
                              ),
                              child: Slider(
                                value: settings.fontScale,
                                min: 0.85,
                                max: 1.30,
                                divisions: 9,
                                onChanged: (v) => notifier.setFontScale(v),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _ScaleChip(
                                  label: 'Kecil (85%)',
                                  scale: 0.85,
                                  current: settings.fontScale,
                                  onTap: () => notifier.setFontScale(0.85),
                                ),
                                _ScaleChip(
                                  label: 'Normal (100%)',
                                  scale: 1.0,
                                  current: settings.fontScale,
                                  onTap: () => notifier.setFontScale(1.0),
                                ),
                                _ScaleChip(
                                  label: 'Besar (115%)',
                                  scale: 1.15,
                                  current: settings.fontScale,
                                  onTap: () => notifier.setFontScale(1.15),
                                ),
                                _ScaleChip(
                                  label: 'Ekstra (130%)',
                                  scale: 1.30,
                                  current: settings.fontScale,
                                  onTap: () => notifier.setFontScale(1.30),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 4. Aksesibilitas Tambahan
                    FadeSlideIn(
                      index: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kenyamanan & Data',
                            style: AppTypography.display(16, weight: 800, color: inkColor),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: surfaceColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              children: [
                                _SwitchSettingRow(
                                  title: 'Kurangi Animasi',
                                  subtitle: 'Mematikan transisi layar dan getaran gerak.',
                                  value: settings.reducedMotion,
                                  onChanged: (v) => notifier.setReducedMotion(v),
                                ),
                                Divider(height: 1, thickness: 1, color: borderColor),
                                _SwitchSettingRow(
                                  title: 'Hemat Data Peta',
                                  subtitle: 'Mengurangi pemuatan ubin peta berulang.',
                                  value: settings.dataSaver,
                                  onChanged: (v) => notifier.setDataSaver(v),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 5. Catatan Desain
                    FadeSlideIn(
                      index: 4,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.sandOf(context),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              LucideIcons.leaf,
                              size: 18,
                              color: primaryColor,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'PawonFood dirancang inklusif. Teks mendukung pembaca layar dan penskalaan hingga 200% tanpa terpotong.',
                                style: AppTypography.text(
                                  12.5,
                                  height: 18,
                                  color: inkMutedColor,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}

class _LivePreviewCard extends StatelessWidget {
  const _LivePreviewCard({required this.fontScale, required this.isDark});

  final double fontScale;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final inkColor = AppColors.inkOf(context);
    final inkMutedColor = AppColors.inkMutedOf(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowOf(context),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'PREVIEW KARTU MAKANAN',
                style: AppTypography.labelExpressive(
                  11.5,
                  weight: 800,
                  color: primaryColor,
                ),
              ),
              const Spacer(),
              const CartoonStampBadge(label: 'Sisa 2 porsi', isUrgent: true, size: 10),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Nasi Sayur Lodeh Hangat',
            style: AppTypography.display(17, weight: 800, color: inkColor),
          ),
          const SizedBox(height: 3),
          Text(
            'Dapur Bu Siti · Pogung (300 m jalan kaki)',
            style: AppTypography.text(13, color: inkMutedColor),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Pill(
                'Bisa jalan kaki',
                size: 11,
                fill: AppColors.sandOf(context),
                color: inkMutedColor,
              ),
              Text(
                'Rp6.000',
                style: AppTypography.display(
                  18,
                  weight: 800,
                  color: primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryOf(context);
    final surfaceColor = AppColors.surfaceOf(context);
    final sandColor = AppColors.sandOf(context);
    final borderColor = AppColors.borderOf(context);
    final inkColor = AppColors.inkOf(context);
    final inkMutedColor = AppColors.inkMutedOf(context);

    final bg = selected ? sandColor : surfaceColor;
    final border = selected ? primaryColor : borderColor;

    return Pressable(
      scale: 0.96,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: border, width: selected ? 1.8 : 1.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: selected ? primaryColor : inkMutedColor,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: AppTypography.labelExpressive(
                    13,
                    weight: selected ? 800 : 500,
                    color: selected ? inkColor : inkMutedColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScaleChip extends StatelessWidget {
  const _ScaleChip({
    required this.label,
    required this.scale,
    required this.current,
    required this.onTap,
  });

  final String label;
  final double scale;
  final double current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selected = (current - scale).abs() < 0.05;
    final primaryColor = AppColors.primaryOf(context);
    final inkMutedColor = AppColors.inkMutedOf(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: AppTypography.labelExpressive(
            11,
            weight: selected ? 800 : 500,
            color: selected ? const Color(0xFFFAF6ED) : inkMutedColor,
          ),
        ),
      ),
    );
  }
}

class _SwitchSettingRow extends StatelessWidget {
  const _SwitchSettingRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final inkColor = AppColors.inkOf(context);
    final inkMutedColor = AppColors.inkMutedOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.display(15, weight: 600, color: inkColor),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            activeTrackColor: primaryColor,
            activeThumbColor: Colors.white,
            inactiveTrackColor: AppColors.sandOf(context),
            inactiveThumbColor: inkMutedColor,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

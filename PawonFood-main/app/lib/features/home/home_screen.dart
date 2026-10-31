import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/data/listings_repository.dart';
import '../../core/data/session_repository.dart';
import '../../core/models/enums.dart';
import '../../core/motion/entrance.dart';
import '../../core/motion/pressable.dart';
import '../../core/services/geo.dart';
import '../../core/services/location_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_chip.dart';
import '../../core/widgets/app_sheet.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/brush_decorations.dart';
import '../../core/widgets/food_card.dart';
import '../../core/widgets/layout_widgets.dart';
import '../../core/widgets/navigation_widgets.dart';
import '../../core/widgets/option_row.dart';
import '../../core/widgets/packed_filter_chip.dart';
import '../../core/widgets/pawon_map.dart';
import '../../core/widgets/pills.dart';
import 'search_screen.dart';

/// B5 Beranda:
/// Redesigned with anti-slop principles:
/// - Minimalist layout with artisanal cartoon brush touches.
/// - Clear focal point: warm neighborhood welcome card with brush underline & steam.
/// - Full adaptive theme support (zero broken/glaring surfaces in Dark Mode).
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final points = ref.watch(sessionProvider.select((u) => u?.points ?? 0));
    final loc = ref.watch(locationProvider);
    final feed = ref.watch(feedProvider);
    final filters = ref.watch(feedFiltersProvider);
    final category = ref.watch(categoryFilterProvider);
    final query = ref.watch(searchQueryProvider);
    final packedOnly = filters.contains(FeedFilter.packed);
    final narrowed = query.trim().isNotEmpty || category != null || packedOnly;
    final radius = ref.watch(radiusMetersProvider);
    final km = (radius / 1000).round();
    final area = loc.name.split(',').first;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = AppColors.surfaceOf(context);
    final sandColor = AppColors.sandOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);

    return EntranceScope(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 12, 16, navContentInset(context)),
          children: [
            // ── Top Bar: Location & Points ─────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    button: true,
                    label: 'Lokasi kamu: ${loc.name}. Ketuk untuk mengubah.',
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _pickLocation(context, ref),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dapur Sekitar',
                              style: AppTypography.text(
                                12,
                                weight: 600,
                                color: AppColors.inkMutedOf(context),
                              ),
                            ),
                            Row(
                              children: [
                                Icon(LucideIcons.mapPin, size: 20, color: primaryColor),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    loc.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTypography.display(
                                      19,
                                      weight: 800,
                                      height: 25,
                                      color: AppColors.inkOf(context),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  LucideIcons.chevronDown,
                                  size: 18,
                                  color: AppColors.inkOf(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                PointsPill(points),
              ],
            ),
            const SizedBox(height: 16),

            // ── Artisanal Neighborhood Greeting Card ──────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: sandColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 1.2),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Clay hearth / soup emblem with steam
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF33251E) : const Color(0xFFFDECE5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accentOf(context).withValues(alpha: 0.35),
                        width: 1.2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        const Positioned(
                          top: -6,
                          child: CartoonSteam(width: 18, height: 12),
                        ),
                        Icon(LucideIcons.soup, size: 20, color: AppColors.accentOf(context)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BrushUnderline(
                          color: primaryColor.withValues(alpha: 0.45),
                          offsetY: 2,
                          child: Text(
                            'Lapar? Masih ada yang hangat.',
                            style: AppTypography.display(
                              17.5,
                              weight: 800,
                              height: 23,
                              color: AppColors.inkOf(context),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Porsi berlebih dari dapur tetangga di $area, siap dinikmati.',
                          style: AppTypography.text(
                            13,
                            color: AppColors.inkMutedOf(context),
                            height: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Minimalist Search & Discovery ─────────────────────────────
            SearchField(
              hint: 'Cari lauk, nasi, sayur rumahan...',
              value: query,
              readOnly: true,
              heroTag: searchHeroTag,
              onTap: () => context.push('/search'),
              onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
            ),
            const SizedBox(height: 12),

            // ── Category Filter Chips ──────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  for (final c in <FoodCategory?>[null, ...FoodCategory.values]) ...[
                    AppChip(
                      label: c?.chip ?? 'All',
                      selected: category == c,
                      onTap: () => ref.read(categoryFilterProvider.notifier).state = c,
                    ),
                    const SizedBox(width: 8),
                  ],
                  const PackedFilterChip(),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // ── Neighborhood Mini Radar / Map ─────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: borderColor, width: 1.0),
                  borderRadius: BorderRadius.circular(20),
                ),
                height: feed.isEmpty ? 92 : 160,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: PawonMap(
                        mini: true,
                        center: loc.position,
                        radiusMeters: radius,
                        listings: [for (final i in feed) i.listing],
                        keepClear: (s) => [
                          const Rect.fromLTWH(0, 0, 240, 48),
                          Rect.fromLTWH(s.width - 72, s.height - 72, 72, 72)
                        ],
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Pill(
                        'Radius $km km${filters.contains(FeedFilter.walkable) ? ' · jalan kaki' : ''}',
                        fill: surfaceColor,
                        color: primaryColor,
                        height: 30,
                        size: 12.5,
                        weight: 700,
                        hPad: 12,
                      ),
                    ),
                    if (feed.isNotEmpty)
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Semantics(
                          button: true,
                          label: 'Buka peta ukuran penuh',
                          child: RoundIconButton(
                            onTap: () => context.go('/map'),
                            semanticLabel: 'Buka peta',
                            fill: primaryColor,
                            borderColor: primaryColor,
                            iconColor: Colors.white,
                            size: 44,
                            shadow: true,
                            iconWidget: const FullscreenIcon(size: 20, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Food Feed / Results ─────────────────────────────────────────
            if (feed.isEmpty && narrowed)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: EmptyState(
                  icon: LucideIcons.searchX,
                  title: query.trim().isNotEmpty
                      ? 'Tidak ada hasil untuk "${query.trim()}"'
                      : 'Belum ada ${category?.label.toLowerCase() ?? 'makanan'}${packedOnly ? ' yang sudah dibungkus' : ''} di sekitarmu',
                  body: 'Coba kata kunci, kategori atau filter lain.',
                ),
              )
            else if (feed.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: EmptyState(
                  image: 'assets/images/brand/berbagi.png',
                  title: 'Belum ada makanan di radius $km km',
                  body: 'Coba perluas radius, atau jadilah yang pertama berbagi di $area.',
                  actions: [
                    if (radius < 2000)
                      AppButton(label: 'Perluas radius ke 2 km', onPressed: () => expandRadius(ref)),
                    AppButton(
                      label: 'Bagikan makananmu',
                      variant: AppButtonVariant.outline,
                      onPressed: () => context.push('/share/camera'),
                    ),
                  ],
                ),
              )
            else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: BrushUnderline(
                      color: primaryColor.withValues(alpha: 0.35),
                      offsetY: 2,
                      strokeWidth: 3.0,
                      child: Text(
                        'Pilihan untukmu di sekitar',
                        style: AppTypography.display(
                          18,
                          weight: 800,
                          height: 24,
                          color: AppColors.inkOf(context),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push('/semua'),
                    style: TextButton.styleFrom(
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: const Size(44, 36),
                    ),
                    child: Text(
                      'Semua',
                      style: AppTypography.labelExpressive(
                        14,
                        weight: 800,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              for (final (i, item) in feed.indexed)
                FadeSlideIn(
                  key: ValueKey(item.listing.id),
                  index: i,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: FoodCard(
                      listing: item.listing,
                      distance: item.distance,
                      onTap: () => context.push('/listing/${item.listing.id}'),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  void _pickLocation(BuildContext context, WidgetRef ref) {
    showAppSheet<void>(
      context: context,
      builder: (ctx) => _LocationSheet(
        onProblem: (issue) => showLocationProblem(context, issue, ref.read(deviceLocatorProvider)),
      ),
    );
  }
}

/// B5c "Ganti lokasi": the phone's GPS position or saved locations.
class _LocationSheet extends ConsumerStatefulWidget {
  const _LocationSheet({required this.onProblem});

  final void Function(LocationIssue issue) onProblem;

  @override
  ConsumerState<_LocationSheet> createState() => _LocationSheetState();
}

class _LocationSheetState extends ConsumerState<_LocationSheet> {
  var _locating = false;

  void _apply(SavedLocation l) {
    ref.read(locationProvider.notifier).select(l);
    ref.read(radiusMetersProvider.notifier).state = walkableRadiusMeters;
    ref.read(feedFiltersProvider.notifier).state = {FeedFilter.walkable};
    Navigator.of(context).pop();
  }

  Future<void> _useGps() async {
    if (_locating) return;
    setState(() => _locating = true);
    final locator = ref.read(deviceLocatorProvider);
    final fix = await locator.locate();
    if (!mounted) return;
    switch (fix) {
      case LocationProblem(:final issue):
        Navigator.of(context).pop();
        widget.onProblem(issue);
      case LocationFound(:final position):
        final name = await locator.placeName(position);
        if (!mounted) return;
        ref.read(lastFixProvider.notifier).state = position;
        _apply(SavedLocation(name ?? currentLocationLabel, position, fromGps: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(locationProvider);
    return SheetBody(
      title: 'Ganti lokasi',
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OptionRow(
            title: 'Gunakan lokasi saat ini',
            subtitle: _locating ? 'Mencari lokasi...' : (current.fromGps ? current.name : 'Pakai GPS ponsel'),
            lead: OptionLead.icon,
            icon: LucideIcons.locateFixed,
            showCheck: true,
            selected: current.fromGps,
            onTap: _useGps,
          ),
        ),
        for (final l in locations)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OptionRow(
              title: l.name,
              lead: OptionLead.icon,
              showCheck: true,
              selected: !current.fromGps && l.name == current.name,
              onTap: () => _apply(l),
            ),
          ),
      ],
    );
  }
}

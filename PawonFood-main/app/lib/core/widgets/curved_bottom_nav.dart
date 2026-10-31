import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../motion/motion.dart';
import '../motion/pressable.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'brand.dart';
import 'brush_decorations.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  Public constants – other screens use these for bottom padding.
// ─────────────────────────────────────────────────────────────────────────────

/// Height of the bar above the system gesture inset.
const double navBarHeight = 68;

/// How far the raised Bagikan button sticks out above the bar.
const double navFabRise = 30;

/// Bottom space a tab screen should leave so content isn't hidden behind the
/// nav bar.
double navContentInset(BuildContext context) =>
    navBarHeight + MediaQuery.paddingOf(context).bottom + 16;

// ─────────────────────────────────────────────────────────────────────────────
//  Tab definitions
// ─────────────────────────────────────────────────────────────────────────────

const _items = <(IconData, String)>[
  (LucideIcons.house, 'Beranda'),
  (LucideIcons.mapPin, 'Peta'),
  (LucideIcons.messageSquare, 'Pesan'),
  (LucideIcons.userRound, 'Profil'),
];

// ─────────────────────────────────────────────────────────────────────────────
//  Notch painter
// ─────────────────────────────────────────────────────────────────────────────

/// Draws the navigation bar surface with a smooth concave notch whose centre
/// sits at [notchCenterX].
class _NavBarPainter extends CustomPainter {
  _NavBarPainter({
    required this.surface,
    required this.border,
    required this.shadow,
    required this.notchCenterX,
  });

  final Color surface;
  final Color border;
  final Color shadow;
  final double notchCenterX;

  static const double _notchRadius = 38; // half‑width of the notch curve
  static const double _notchDepth = 32;  // how deep the notch dips

  @override
  void paint(Canvas canvas, Size size) {
    // ── Shadow ──────────────────────────────────────────────────────────────
    final shadowPaint = Paint()
      ..color = shadow
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final shadowPath = _buildPath(size, yShift: 2);
    canvas.drawPath(shadowPath, shadowPaint);

    // ── Fill ────────────────────────────────────────────────────────────────
    final fillPaint = Paint()
      ..color = surface
      ..style = PaintingStyle.fill;

    final path = _buildPath(size);
    canvas.drawPath(path, fillPaint);

    // ── Top border ─────────────────────────────────────────────────────────
    final borderPaint = Paint()
      ..color = border
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, borderPaint);
  }

  Path _buildPath(Size size, {double yShift = 0}) {
    final cx = notchCenterX;
    final r = _notchRadius;
    final d = _notchDepth + yShift;

    return Path()
      ..moveTo(0, yShift)
      ..lineTo(cx - r - 10, yShift) // flat left
      // ease into the notch
      ..cubicTo(
        cx - r, yShift,
        cx - r + 6, yShift,
        cx - r + 12, d * 0.45,
      )
      // bottom of the notch
      ..cubicTo(
        cx - r + 20, d,
        cx + r - 20, d,
        cx + r - 12, d * 0.45,
      )
      // ease out of the notch
      ..cubicTo(
        cx + r - 6, yShift,
        cx + r, yShift,
        cx + r + 10, yShift,
      )
      ..lineTo(size.width, yShift) // flat right
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldRepaint(covariant _NavBarPainter old) =>
      old.notchCenterX != notchCenterX ||
      old.surface != surface ||
      old.border != border;
}

// ─────────────────────────────────────────────────────────────────────────────
//  CurvedBottomNav
// ─────────────────────────────────────────────────────────────────────────────

/// Bottom navigation bar with a smooth curved notch and a floating centre
/// "Bagikan" action.
///
/// The notch slides horizontally to follow the selected tab, giving a
/// polished, reference‑image‑matching animation.
class CurvedBottomNav extends StatefulWidget {
  const CurvedBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onShare,
  });

  /// 0‑3 for the four tabs: Beranda, Peta, Pesan, Profil.
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onShare;

  @override
  State<CurvedBottomNav> createState() => _CurvedBottomNavState();
}

class _CurvedBottomNavState extends State<CurvedBottomNav>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _notchX; // animated notch centre‑X

  /// We compute the per‑slot centres once per layout via [_slotCentres].
  /// Slots: 0 = tab 0, 1 = tab 1, 2 = Bagikan, 3 = tab 2, 4 = tab 3.
  List<double> _slotCentres = [];

  /// Map tab index (0‑3) to slot index (0, 1, 3, 4) – slot 2 is Bagikan.
  static int _tabToSlot(int tab) => tab < 2 ? tab : tab + 1;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: Motion.base,
    );
    // Placeholder tween — we'll set the real one in didChangeDependencies.
    _notchX = AlwaysStoppedAnimation(0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _recalcSlotCentres();

    // If the animation hasn't started yet (first build), snap to position.
    if (!_ctrl.isAnimating && _ctrl.value == 0) {
      final target = _slotCentres[_tabToSlot(widget.currentIndex)];
      _notchX = AlwaysStoppedAnimation(target);
    }
  }

  void _recalcSlotCentres() {
    final w = MediaQuery.sizeOf(context).width;
    // 5 equal‑width slots: [tab0] [tab1] [Bagikan] [tab2] [tab3]
    final slotW = w / 5;
    _slotCentres = List.generate(5, (i) => slotW * i + slotW / 2);
  }

  @override
  void didUpdateWidget(covariant CurvedBottomNav old) {
    super.didUpdateWidget(old);

    if (old.currentIndex != widget.currentIndex) {
      _recalcSlotCentres();
      final from = _notchX.value;
      final to = _slotCentres[_tabToSlot(widget.currentIndex)];

      _notchX = Tween<double>(begin: from, end: to).animate(
        CurvedAnimation(parent: _ctrl, curve: Motion.pop),
      );
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── Single tab item ─────────────────────────────────────────────────────

  Widget _tab(BuildContext context, int tabIndex) {
    final (icon, label) = _items[tabIndex];
    final isOn = tabIndex == widget.currentIndex;
    final primary = AppColors.primaryOf(context);
    final muted = AppColors.inkMutedOf(context);
    final color = isOn ? primary : muted;

    return Expanded(
      child: Semantics(
        button: true,
        selected: isOn,
        label: label,
        child: InkResponse(
          onTap: () => widget.onTap(tabIndex),
          radius: 38,
          highlightShape: BoxShape.circle,
          child: SizedBox(
            height: navBarHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isOn ? 1.08 : 0.95,
                  duration: Motion.base,
                  curve: Motion.pop,
                  child: Icon(icon, size: 24, color: color),
                ),
                const SizedBox(height: 3),
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
                          weight: isOn ? 800 : 500,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedOpacity(
                        opacity: isOn ? 1.0 : 0.0,
                        duration: Motion.base,
                        child: AnimatedContainer(
                          duration: Motion.base,
                          curve: Curves.easeOutCubic,
                          height: 2.5,
                          width: isOn ? 18 : 0,
                          decoration: BoxDecoration(
                            color: primary,
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

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.paddingOf(context).bottom;
    final surfaceColor = AppColors.surfaceOf(context);
    final borderColor = AppColors.borderOf(context);
    final primaryColor = AppColors.primaryOf(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: navBarHeight + inset + navFabRise,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Bar with animated notch ──────────────────────────────────────
          Positioned(
            top: navFabRise,
            left: 0,
            right: 0,
            bottom: 0,
            child: AnimatedBuilder(
              animation: _notchX,
              builder: (_, __) => CustomPaint(
                painter: _NavBarPainter(
                  surface: surfaceColor,
                  border: borderColor,
                  shadow: AppColors.shadowOf(context),
                  notchCenterX: _notchX.value,
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: inset),
                  child: Row(
                    children: [
                      _tab(context, 0),
                      _tab(context, 1),
                      // Centre slot placeholder (same width as a tab)
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
                                    color: AppColors.accentOf(context)
                                        .withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      _tab(context, 2),
                      _tab(context, 3),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Floating Bagikan button ─────────────────────────────────────
          Positioned(
            top: 2,
            left: 0,
            right: 0,
            child: Center(
              child: Semantics(
                button: true,
                label: 'Bagikan makanan',
                child: GestureDetector(
                  onTap: widget.onShare,
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
                          color: isDark
                              ? AppColors.borderStrongOf(context)
                              : AppColors.surfaceSand,
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
                              isDark
                                  ? const Color(0xFF2E5E3A)
                                  : AppColors.primaryDark,
                            ],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            PawonLogo(size: 28, color: Color(0xFFFAF6ED)),
                            Positioned(
                              top: 4,
                              child: CartoonSteam(
                                width: 16,
                                height: 10,
                                color: Color(0x60FAF6ED),
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
          ),
        ],
      ),
    );
  }
}


/// Backwards‑compatible alias so existing code that references
/// [PawonBottomNav] keeps compiling.
typedef PawonBottomNav = CurvedBottomNav;

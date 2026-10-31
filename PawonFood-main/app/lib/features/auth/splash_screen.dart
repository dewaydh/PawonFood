import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/data/onboarding_repository.dart';
import '../../core/data/session_repository.dart';
import '../../core/motion/motion.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/widgets/brand.dart';
import '../../core/widgets/pills.dart';

/// Provider to track if the splash screen has completed in this session.
final splashSeenProvider = StateProvider<bool>((ref) => false);

/// Anti-slop splash screen: authentic handcrafted kitchen warmth using the Tungku-Lensa mark,
/// wordmark, and subtle culinary steam animation without generic AI floating particles.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _hearthGlow;
  late final Animation<double> _steamProgress;
  late final Animation<double> _wordmarkFade;
  late final Animation<Offset> _wordmarkSlide;
  late final Animation<double> _taglineFade;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _footerFade;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    // 1. Logo Tungku reveals with organic scale & fade
    _logoScale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
      ),
    );

    // 2. Hearth warm glow expands gently behind the stove
    _hearthGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.20, 0.60, curve: Curves.easeInOutCubic),
      ),
    );

    // 3. Gentle steam wisps rise upward from the stove
    _steamProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 0.85, curve: Curves.easeInOut),
      ),
    );

    // 4. Wordmark enters with soft upward drift
    _wordmarkFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.40, 0.70, curve: Curves.easeOut),
      ),
    );
    _wordmarkSlide =
        Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.40, 0.75, curve: Motion.enter),
          ),
        );

    // 5. Slogan & purpose tagline
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.60, 0.88, curve: Curves.easeOut),
      ),
    );
    _taglineSlide =
        Tween<Offset>(begin: const Offset(0, 0.20), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.60, 0.90, curve: Motion.enter),
          ),
        );

    // 6. Subtle footer
    _footerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward().then((_) {
      if (mounted) _proceed();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context) && !_navigated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _proceed();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _proceed() {
    if (_navigated || !mounted) return;
    _navigated = true;
    ref.read(splashSeenProvider.notifier).state = true;

    final onboarded = ref.read(onboardingSeenProvider);
    final signedIn = ref.read(sessionProvider) != null;

    if (!onboarded) {
      context.go('/onboarding');
    } else if (!signedIn) {
      context.go('/welcome');
    } else {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = AppColors.backgroundOf(context);
    final sand = AppColors.sandOf(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: bg,
        body: GestureDetector(
          onTap: _proceed, // Tap to immediately skip
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              // 1. Subtle warm radial ambient background
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.1),
                      radius: 0.9,
                      colors: [
                        sand.withValues(alpha: 0.75),
                        bg,
                      ],
                    ),
                  ),
                ),
              ),

              // 2. Central Brand Composition
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tungku Logo with animated steam and hearth glow
                      AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Warm terracotta hearth glow behind the tungku aperture
                              Transform.scale(
                                scale: 0.8 + 0.4 * _hearthGlow.value,
                                child: Container(
                                  width: 110,
                                  height: 110,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: RadialGradient(
                                      colors: [
                                        AppColors.accent.withValues(
                                          alpha: 0.20 * _hearthGlow.value,
                                        ),
                                        AppColors.accent.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Steam Wisps rising above the tungku
                              Positioned(
                                top: -38,
                                left: 0,
                                right: 0,
                                child: SizedBox(
                                  height: 48,
                                  child: CustomPaint(
                                    painter: _KitchenSteamPainter(
                                      progress: _steamProgress.value,
                                      color: AppColors.accent.withValues(
                                        alpha: 0.45,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Tungku Logo mark
                              Transform.scale(
                                scale: _logoScale.value,
                                child: Opacity(
                                  opacity: _logoFade.value,
                                  child: Container(
                                    padding: const EdgeInsets.all(22),
                                    decoration: BoxDecoration(
                                      color: AppColors.surfaceOf(context),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.borderOf(context).withValues(
                                          alpha: 0.8,
                                        ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark
                                              ? Colors.black.withValues(alpha: 0.3)
                                              : const Color(0xFF203D27).withValues(alpha: 0.06),
                                          blurRadius: 18,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: PawonLogo(
                                      size: 64,
                                      color: AppColors.primaryOf(context),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 26),

                      // Wordmark ("PawonFood" brush logo with Hero transition)
                      SlideTransition(
                        position: _wordmarkSlide,
                        child: FadeTransition(
                          opacity: _wordmarkFade,
                          child: const Hero(
                            tag: 'brand_wordmark',
                            child: Wordmark(width: 200),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Community Slogan & Tagline
                      SlideTransition(
                        position: _taglineSlide,
                        child: FadeTransition(
                          opacity: _taglineFade,
                          child: Column(
                            children: [
                              Text(
                                'Dari dapur rumah tangga ke komunitas',
                                textAlign: TextAlign.center,
                                style: AppTypography.display(
                                  16,
                                  weight: 700,
                                  height: 22,
                                  color: AppColors.inkOf(context),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Pill(
                                'Masak lebih? Jual & bagikan tanpa ribet',
                                fill: AppColors.sandOf(context),
                                color: isDark ? const Color(0xFFFFB499) : AppColors.accentInk,
                                size: 12,
                                weight: 600,
                                hPad: 14,
                                height: 30,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Bottom Footer (Earthy, Honest & Community-focused)
              Positioned(
                bottom: 32,
                left: 20,
                right: 20,
                child: FadeTransition(
                  opacity: _footerFade,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.primaryOf(context),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Pogung, Sleman · Hyperlocal Food Sharing',
                            style: AppTypography.text(
                              12,
                              weight: 600,
                              color: AppColors.inkMutedOf(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Ketuk di mana saja untuk melanjutkan',
                        style: AppTypography.caption.copyWith(
                          color: AppColors.inkMutedOf(context).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom painter that draws authentic, gentle culinary steam wisps rising from the hearth.
class _KitchenSteamPainter extends CustomPainter {
  const _KitchenSteamPainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0.05) return;

    final paint = Paint()
      ..color = color.withValues(
        alpha: (1.0 - (progress * 0.4)).clamp(0.0, 1.0) * color.a,
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // 3 wavy gentle steam wisps (left, center, right)
    _drawSteamWisp(
      canvas,
      paint,
      Offset(w * 0.42, h),
      Offset(w * 0.38, h * 0.1),
      progress,
      shift: 0.0,
    );
    _drawSteamWisp(
      canvas,
      paint,
      Offset(w * 0.50, h),
      Offset(w * 0.52, 0),
      progress,
      shift: 0.3,
    );
    _drawSteamWisp(
      canvas,
      paint,
      Offset(w * 0.58, h),
      Offset(w * 0.62, h * 0.15),
      progress,
      shift: 0.6,
    );
  }

  void _drawSteamWisp(
    Canvas canvas,
    Paint paint,
    Offset start,
    Offset end,
    double t, {
    required double shift,
  }) {
    final effectiveT = ((t + shift * 0.25)).clamp(0.0, 1.0);
    if (effectiveT <= 0.05) return;

    final path = Path();
    path.moveTo(start.dx, start.dy);

    final currentEndDy = start.dy - (start.dy - end.dy) * effectiveT;
    final wave = math.sin((effectiveT + shift) * math.pi * 2) * 6;

    final midY = (start.dy + currentEndDy) / 2;
    path.cubicTo(
      start.dx + wave,
      start.dy - (start.dy - midY) * 0.5,
      start.dx - wave,
      midY,
      end.dx + wave * 0.5,
      currentEndDy,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _KitchenSteamPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

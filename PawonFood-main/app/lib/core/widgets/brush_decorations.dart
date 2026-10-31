import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Artisanal Cartoon Brush & Hand-drawn accents.
/// Gives PawonFood an authentic "dapur rumahan", warm neighborhood aesthetic
/// while maintaining clean minimalist restraint.

/// A lively, hand-drawn brush stroke underline for headers and focal phrases.
class BrushUnderline extends StatelessWidget {
  const BrushUnderline({
    super.key,
    required this.child,
    this.color,
    this.strokeWidth = 3.5,
    this.offsetY = 2.0,
  });

  final Widget child;
  final Color? color;
  final double strokeWidth;
  final double offsetY;

  @override
  Widget build(BuildContext context) {
    final brushColor = color ?? AppColors.primaryOf(context).withValues(alpha: 0.65);
    return CustomPaint(
      painter: _BrushUnderlinePainter(
        color: brushColor,
        strokeWidth: strokeWidth,
        offsetY: offsetY,
      ),
      child: child,
    );
  }
}

class _BrushUnderlinePainter extends CustomPainter {
  _BrushUnderlinePainter({
    required this.color,
    required this.strokeWidth,
    required this.offsetY,
  });

  final Color color;
  final double strokeWidth;
  final double offsetY;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final path = Path();
    final y = size.height + offsetY;
    path.moveTo(2, y);

    // Subtle natural organic waviness like a quick watercolor/calligraphy brush
    final w = size.width;
    path.cubicTo(
      w * 0.25,
      y + 1.2,
      w * 0.70,
      y - 1.8,
      w - 2,
      y + 0.5,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_BrushUnderlinePainter oldDelegate) =>
      color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
}

/// Cartoon / artisanal stamp badge for urgent or special food tags ("GRATIS", "Sisa 2 porsi", etc.)
/// Styled like a cozy warung / kitchen hand-stamp.
class CartoonStampBadge extends StatelessWidget {
  const CartoonStampBadge({
    super.key,
    required this.label,
    this.isGratis = false,
    this.isUrgent = false,
    this.size = 11.5,
  });

  final String label;
  final bool isGratis;
  final bool isUrgent;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color bg;
    final Color textColor;
    final Color borderColor;

    if (isGratis) {
      bg = isDark ? const Color(0xFF1E3825) : const Color(0xFFE5EFE6);
      textColor = isDark ? const Color(0xFF81C784) : AppColors.primary;
      borderColor = isDark ? const Color(0xFF386641) : AppColors.primary.withValues(alpha: 0.35);
    } else if (isUrgent) {
      bg = isDark ? const Color(0xFF38231C) : const Color(0xFFFBECE6);
      textColor = isDark ? const Color(0xFFFFAB91) : AppColors.accent;
      borderColor = isDark ? const Color(0xFF6E3827) : AppColors.accent.withValues(alpha: 0.35);
    } else {
      bg = AppColors.sandOf(context);
      textColor = AppColors.inkOf(context);
      borderColor = AppColors.borderOf(context);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(7),
        ),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isGratis) ...[
            Icon(Icons.eco_rounded, size: size + 2, color: textColor),
            const SizedBox(width: 4),
          ] else if (isUrgent) ...[
            Icon(Icons.local_fire_department_rounded, size: size + 2, color: textColor),
            const SizedBox(width: 3),
          ],
          Text(
            label,
            style: AppTypography.labelExpressive(
              size,
              weight: 800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stylized, cozy kitchen steam wisps rising from hearth / food banners.
class CartoonSteam extends StatelessWidget {
  const CartoonSteam({super.key, this.width = 30, this.height = 20, this.color});

  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final steamColor = color ?? AppColors.accentOf(context).withValues(alpha: 0.45);
    return CustomPaint(
      size: Size(width, height),
      painter: _CartoonSteamPainter(color: steamColor),
    );
  }
}

class _CartoonSteamPainter extends CustomPainter {
  _CartoonSteamPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final w = size.width;
    final h = size.height;

    // First gentle wavy curl
    final p1 = Path();
    p1.moveTo(w * 0.3, h);
    p1.cubicTo(w * 0.2, h * 0.6, w * 0.45, h * 0.35, w * 0.35, 0);
    canvas.drawPath(p1, paint);

    // Second taller center wisp
    final p2 = Path();
    p2.moveTo(w * 0.6, h);
    p2.cubicTo(w * 0.75, h * 0.65, w * 0.5, h * 0.3, w * 0.65, 0);
    canvas.drawPath(p2, paint);
  }

  @override
  bool shouldRepaint(_CartoonSteamPainter oldDelegate) => color != oldDelegate.color;
}


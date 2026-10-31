import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../theme/app_colors.dart';

/// A QR code on a high-contrast white rounded tile (provider's pickup QR, QRIS).
/// Requirement: Must remain scannable in both Light and Dark themes.
/// Uses a dark QR foreground on a clean white background.
class QrBox extends StatelessWidget {
  const QrBox({
    super.key,
    required this.data,
    this.size = 236,
    this.semanticLabel = 'Kode QR',
    this.border = true,
  });

  final String data;
  final double size;
  final String semanticLabel;
  final bool border;

  @override
  Widget build(BuildContext context) => Semantics(
    label: semanticLabel,
    image: true,
    child: Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.05),
      decoration: BoxDecoration(
        color:
            AppColors.qrBg, // Always pure white for optical scanner reliability
        borderRadius: BorderRadius.circular(16),
        border: border
            ? Border.all(color: AppColors.borderOf(context), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowOf(context),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: QrImageView(
        data: data,
        padding: EdgeInsets.zero,
        backgroundColor: AppColors.qrBg,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: AppColors.qrFg,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: AppColors.qrFg,
        ),
      ),
    ),
  );
}

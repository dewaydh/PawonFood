import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Wraps the application in an elegant smartphone frame when viewed on desktop or tablet
/// browsers (similar to Figma prototype presentation), while remaining completely fullscreen
/// and native when opened on mobile devices.
class PhoneFramePreview extends StatelessWidget {
  const PhoneFramePreview({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // On native mobile platforms or small screens (smartphones), display fullscreen.
    if (!kIsWeb) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // If viewport width is wider than typical mobile screens (e.g. laptop/desktop browser)
        if (constraints.maxWidth > 520) {
          return Scaffold(
            backgroundColor: const Color(0xFF13151A), // Deep studio backdrop
            body: Stack(
              children: [
                // Subtle decorative radial glow behind the phone mockup
                Positioned.fill(
                  child: Center(
                    child: Container(
                      width: 500,
                      height: 940,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF2E5E3A).withValues(alpha: 0.15),
                            Colors.transparent,
                          ],
                          radius: 0.7,
                        ),
                      ),
                    ),
                  ),
                ),

                // Main Phone Mockup centered
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        width: 412,
                        height: 880,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(46),
                          border: Border.all(
                            color: const Color(0xFF2E323B),
                            width: 8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.55),
                              blurRadius: 40,
                              offset: const Offset(0, 18),
                            ),
                            BoxShadow(
                              color: const Color(0xFF2E5E3A).withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(38),
                          child: Stack(
                            children: [
                              // The actual app
                              Positioned.fill(child: child),

                              // Sleek minimal punch-hole camera at the top
                              Positioned(
                                top: 12,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    width: 14,
                                    height: 14,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF0F1015),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Container(
                                        width: 4,
                                        height: 4,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1E293B),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

        // Native fullscreen experience on mobile web browsers
        return child;
      },
    );
  }
}


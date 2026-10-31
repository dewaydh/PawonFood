import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawonfood/core/widgets/brand.dart';
import 'package:pawonfood/features/auth/splash_screen.dart';

import 'support.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('SplashScreen displays brand elements (logo, wordmark, tagline)', (tester) async {
    usePhoneScreen(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(),
        child: const MaterialApp(
          home: SplashScreen(),
        ),
      ),
    );

    // Initial frame
    await tester.pump();

    // Verify brand assets and texts are present
    expect(find.byType(PawonLogo), findsOneWidget);
    expect(find.byType(Wordmark), findsOneWidget);
    expect(find.text('Dari dapur rumah tangga ke komunitas'), findsOneWidget);
    expect(find.text('Masak lebih? Jual & bagikan tanpa ribet'), findsOneWidget);
    expect(find.text('Pogung, Sleman · Hyperlocal Food Sharing'), findsOneWidget);
  });
}


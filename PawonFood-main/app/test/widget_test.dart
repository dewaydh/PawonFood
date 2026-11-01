import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pawonfood/app.dart';

import 'support.dart';

void main() {
  setUpAll(loadAppFonts);

  testWidgets('PawonApp smoke test - builds and renders root frame', (WidgetTester tester) async {
    usePhoneScreen(tester);

    // Build PawonFood app with required mock providers.
    await tester.pumpWidget(
      ProviderScope(
        overrides: testOverrides(),
        child: const PawonApp(),
      ),
    );

    // Pump a frame to settle initial state.
    await tester.pump();

    // Verify root PawonApp is mounted successfully.
    expect(find.byType(PawonApp), findsOneWidget);
  });
}


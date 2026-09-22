// Basic smoke test for the SKM Egg app shell.
//
// This verifies the app boots to the splash screen without throwing.
// Deeper flow tests (login -> dashboard) can be added once auth/state
// wiring stabilizes across phases.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:skm_erp_new/app/app.dart';
import 'package:skm_erp_new/core/constants/app_strings.dart';

void main() {
  testWidgets('App shows splash screen with SKM Egg branding on startup', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SkmEggApp()));
    await tester.pump();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);

    // Let the splash screen's startup timer fire before the tree is
    // disposed, otherwise the test framework flags a pending Timer.
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}

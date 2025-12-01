import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/router/app_router.dart' as app_router;

void main() {
  testWidgets('About route opens AboutUsPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp.router(routerConfig: app_router.AppRouter.router),
    );

    // Navigate to /about
    app_router.AppRouter.router.go('/about');

    await tester.pumpAndSettle();

    expect(find.text('About Us'), findsOneWidget);
    expect(find.text('Rise Bakery'), findsOneWidget);
  });
}

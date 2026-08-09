import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  testWidgets('OnboardingScreen renders step 1 welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    expect(find.text('Welcome to Tripcraft'), findsOneWidget);
    expect(find.text("Let's get started"), findsOneWidget);
  });
}

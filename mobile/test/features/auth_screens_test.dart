import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/authentication/presentation/providers/auth_provider.dart';
import 'package:tripcraft/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:tripcraft/features/authentication/presentation/screens/login_screen.dart';
import 'package:tripcraft/features/authentication/presentation/screens/verify_email_screen.dart';
import '../helpers/mock_auth_repository.dart';

void main() {
  testWidgets('LoginScreen renders header and input fields', (WidgetTester tester) async {
    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.text('Continue with Apple'), findsOneWidget);
  });

  testWidgets('ForgotPasswordScreen renders title and send button', (WidgetTester tester) async {
    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: const MaterialApp(
          home: ForgotPasswordScreen(),
        ),
      ),
    );

    expect(find.text('Forgot your password?'), findsOneWidget);
    expect(find.text('Send reset link'), findsOneWidget);
  });

  testWidgets('VerifyEmailScreen renders title and verify button', (WidgetTester tester) async {
    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: const MaterialApp(
          home: VerifyEmailScreen(),
        ),
      ),
    );

    expect(find.text('Check your inbox'), findsOneWidget);
    expect(find.text("I've verified my email"), findsOneWidget);
  });
}

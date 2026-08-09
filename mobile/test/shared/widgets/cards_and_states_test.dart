import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/shared/widgets/cards/app_card.dart';
import 'package:tripcraft/shared/widgets/loading/loading_indicator.dart';
import 'package:tripcraft/shared/widgets/states/empty_state.dart';
import 'package:tripcraft/shared/widgets/states/error_state.dart';

void main() {
  testWidgets('AppCard renders child content', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppCard(
            child: Text('Card Content'),
          ),
        ),
      ),
    );

    expect(find.text('Card Content'), findsOneWidget);
  });

  testWidgets('EmptyState renders title, description and button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EmptyState(
            title: 'No Trips',
            description: 'No trips saved',
            actionLabel: 'Create',
            onAction: () {},
          ),
        ),
      ),
    );

    expect(find.text('No Trips'), findsOneWidget);
    expect(find.text('No trips saved'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
  });

  testWidgets('ErrorState renders error message and retry button', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ErrorState(
            title: 'Failed',
            description: 'Error occurred',
            onRetry: () {},
          ),
        ),
      ),
    );

    expect(find.text('Failed'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
  });

  testWidgets('LoadingIndicator renders message', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LoadingIndicator(message: 'Please wait'),
        ),
      ),
    );

    expect(find.text('Please wait'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/app/app.dart';
import 'package:tripcraft/features/authentication/presentation/providers/auth_provider.dart';
import 'helpers/mock_auth_repository.dart';

void main() {
  testWidgets('TripCraft App smoke test', (WidgetTester tester) async {
    final mockRepo = MockAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
        child: const TripCraftApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(TripCraftApp), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/app/app.dart';

void main() {
  testWidgets('TripCraft App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TripCraftApp());
    await tester.pump(const Duration(milliseconds: 500));

    // Verify that our app starts and displays the design system showcase.
    expect(find.text('TripCraft Design System'), findsOneWidget);
  });
}

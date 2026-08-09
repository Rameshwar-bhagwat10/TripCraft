import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/itinerary/domain/entities/itinerary.dart';
import 'package:tripcraft/features/itinerary/domain/repositories/itinerary_repository.dart';
import 'package:tripcraft/features/itinerary/presentation/providers/itinerary_provider.dart';
import 'package:tripcraft/features/itinerary/presentation/screens/itinerary_screen.dart';

class FakeItineraryRepository implements ItineraryRepository {
  final Itinerary itinerary;

  FakeItineraryRepository(this.itinerary);

  @override
  Future<Itinerary> getItinerary(String tripId) async => itinerary;

  @override
  Future<ItineraryItem> createItineraryItem(String tripId, String dayId, Map<String, dynamic> body) async {
    return itinerary.days.first.items.first;
  }

  @override
  Future<ItineraryItem> updateItineraryItem(String tripId, String itemId, Map<String, dynamic> body) async {
    return itinerary.days.first.items.first;
  }

  @override
  Future<bool> deleteItineraryItem(String tripId, String itemId) async => true;

  @override
  Future<bool> reorderItineraryItems(String tripId, String dayId, List<Map<String, dynamic>> items) async => true;

  @override
  Future<ItineraryItem> moveItineraryItem(String tripId, String itemId, String targetDayId, int newOrderIndex) async {
    return itinerary.days.first.items.first;
  }

  @override
  Future<TripDay> updateTripDay(String tripId, String dayId, Map<String, dynamic> body) async {
    return itinerary.days.first;
  }
}

void main() {
  testWidgets('ItineraryScreen renders header, day selector and timeline activity item', (WidgetTester tester) async {
    final mockItinerary = Itinerary(
      tripId: 'test-trip-1',
      days: [
        TripDay(
          id: 'day-1',
          tripId: 'test-trip-1',
          date: '2026-08-21',
          dayNumber: 1,
          title: 'Old Goa & Heritage',
          items: [
            ItineraryItem(
              id: 'item-1',
              tripDayId: 'day-1',
              title: 'Explore Fort Aguada',
              type: ActivityType.sightseeing,
              startTime: '10:30',
              endTime: '12:30',
              duration: '2h',
              createdAt: '',
              updatedAt: '',
            ),
          ],
          createdAt: '',
          updatedAt: '',
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          itineraryRepositoryProvider.overrideWithValue(FakeItineraryRepository(mockItinerary)),
        ],
        child: const MaterialApp(
          home: ItineraryScreen(tripId: 'test-trip-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Itinerary Builder'), findsOneWidget);
    expect(find.textContaining('DAY 1'), findsOneWidget);
    expect(find.text('Explore Fort Aguada'), findsOneWidget);
  });
}

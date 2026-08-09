import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/trips/domain/entities/trip.dart';
import 'package:tripcraft/features/trips/domain/repositories/trips_repository.dart';
import 'package:tripcraft/features/trips/presentation/providers/trips_provider.dart';
import 'package:tripcraft/features/trips/presentation/screens/trips_screen.dart';

class FakeTripsRepository implements TripsRepository {
  final List<Trip> trips;

  FakeTripsRepository(this.trips);

  @override
  Future<Trip> createTrip(Map<String, dynamic> body) async => trips.first;

  @override
  Future<List<Trip>> getTrips(TripFilter filter) async => trips;

  @override
  Future<Trip> getTripById(String id) async => trips.first;

  @override
  Future<Trip> updateTrip(String id, Map<String, dynamic> body) async => trips.first;

  @override
  Future<Trip> archiveTrip(String id) async => trips.first;

  @override
  Future<Trip> restoreTrip(String id) async => trips.first;

  @override
  Future<bool> deleteTrip(String id) async => true;
}

void main() {
  testWidgets('TripsScreen renders header and segmented tabs', (WidgetTester tester) async {
    final mockTrips = [
      Trip(
        id: 'test-trip-1',
        ownerId: 'user-1',
        destinationId: 'dest-goa',
        title: 'Goa Coastal Escape',
        coverImage: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=800',
        startDate: '2026-08-21',
        endDate: '2026-08-25',
        status: TripStatus.upcoming,
        travelersCount: 2,
        createdAt: '2026-08-09T00:00:00Z',
        updatedAt: '2026-08-09T00:00:00Z',
      ),
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripsRepositoryProvider.overrideWithValue(FakeTripsRepository(mockTrips)),
        ],
        child: const MaterialApp(
          home: TripsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Trips'), findsOneWidget);
    expect(find.textContaining('Upcoming'), findsOneWidget);
    expect(find.textContaining('Past'), findsOneWidget);
    expect(find.textContaining('Archived'), findsOneWidget);
    expect(find.text('Goa Coastal Escape'), findsOneWidget);
  });
}

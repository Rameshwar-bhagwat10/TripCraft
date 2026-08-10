import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/trip_operations/data/repositories/trip_operations_repository_impl.dart';
import 'package:tripcraft/features/trip_operations/domain/entities/booking.dart';
import 'package:tripcraft/features/trip_operations/domain/entities/travel_document.dart';
import 'package:tripcraft/features/trip_operations/presentation/providers/trip_operations_provider.dart';
import 'package:tripcraft/features/trip_operations/presentation/screens/trip_operations_screen.dart';

class FakeTripOperationsRepository implements TripOperationsRepositoryImpl {
  @override
  Future<List<Booking>> getBookings(String tripId) async {
    return [
      Booking(
        id: 'book-1',
        tripId: tripId,
        type: BookingType.flight,
        title: 'IndiGo Flight 6E-204',
        providerName: 'IndiGo',
        confirmationNumber: '6E-PNR-8849',
        status: BookingStatus.confirmed,
        startDateTime: '2026-08-21T08:30:00Z',
        createdAt: DateTime.now().toIso8601String(),
      ),
    ];
  }

  @override
  Future<List<TravelDocument>> getDocuments(String tripId) async {
    return [
      TravelDocument(
        id: 'doc-1',
        tripId: tripId,
        title: 'IndiGo Flight Ticket.pdf',
        category: DocumentCategory.transport,
        fileType: 'pdf',
        fileSizeBytes: 450000,
        storagePath: 'private/doc.pdf',
        uploadedAt: DateTime.now().toIso8601String(),
      ),
    ];
  }

  @override
  Future<TripOperationsSummary> getOperationsSummary(String tripId) async {
    return TripOperationsSummary(
      tripId: tripId,
      readinessScore: 95,
      readinessStatus: 'ready',
      summary: '1 of 1 bookings confirmed with ticket attached.',
      totalBookings: 1,
      confirmedBookingsCount: 1,
      totalDocumentsCount: 1,
      attentionItems: const [],
    );
  }

  @override
  Future<Booking> createBooking(String tripId, Map<String, dynamic> body) async {
    return Booking(
      id: 'book-new',
      tripId: tripId,
      type: BookingType.hotel,
      title: 'Taj Hotel',
      providerName: 'Taj',
      confirmationNumber: 'REF-123',
      status: BookingStatus.confirmed,
      startDateTime: DateTime.now().toIso8601String(),
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<TravelDocument> createDocument(String tripId, Map<String, dynamic> body) async {
    return TravelDocument(
      id: 'doc-new',
      tripId: tripId,
      title: 'Voucher.pdf',
      category: DocumentCategory.accommodation,
      fileType: 'pdf',
      fileSizeBytes: 100000,
      storagePath: 'path',
      uploadedAt: DateTime.now().toIso8601String(),
    );
  }
}

void main() {
  testWidgets('TripOperationsScreen renders readiness score, bookings and document vault buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tripOperationsRepositoryProvider.overrideWithValue(FakeTripOperationsRepository()),
        ],
        child: const MaterialApp(
          home: TripOperationsScreen(tripId: 'test-trip-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Trip Operations & Vault'), findsOneWidget);
    expect(find.text('95% READINESS'), findsOneWidget);
    expect(find.text('Add Booking'), findsOneWidget);
    expect(find.text('Upload Ticket'), findsOneWidget);
  });
}

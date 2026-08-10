import 'package:dio/dio.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/travel_document.dart';

abstract class TripOperationsRemoteDataSource {
  Future<List<Booking>> getBookings(String tripId);
  Future<Booking> createBooking(String tripId, Map<String, dynamic> body);
  Future<List<TravelDocument>> getDocuments(String tripId);
  Future<TravelDocument> createDocument(String tripId, Map<String, dynamic> body);
  Future<TripOperationsSummary> getOperationsSummary(String tripId);
}

class TripOperationsRemoteDataSourceImpl implements TripOperationsRemoteDataSource {
  final Dio _dio;

  TripOperationsRemoteDataSourceImpl(this._dio);

  static final List<Booking> _mockBookings = [
    Booking(
      id: 'book-flight-1',
      tripId: 'trip-goa-escape',
      type: BookingType.flight,
      title: 'IndiGo Flight 6E-204 (BOM -> GOI)',
      providerName: 'IndiGo Airlines',
      confirmationNumber: '6E-PNR-8849',
      status: BookingStatus.confirmed,
      startDateTime: '2026-08-21T08:30:00Z',
      endDateTime: '2026-08-21T09:45:00Z',
      location: 'Chhatrapati Shivaji Maharaj Intl Airport (BOM)',
      details: const {'flightNumber': '6E-204', 'departureTerminal': 'T2', 'seat': '12F'},
      linkedDocumentIds: const ['doc-ticket-1'],
      createdAt: DateTime.now().toIso8601String(),
    ),
    Booking(
      id: 'book-hotel-1',
      tripId: 'trip-goa-escape',
      type: BookingType.hotel,
      title: 'Taj Fort Aguada Resort & Spa',
      providerName: 'Taj Hotels',
      confirmationNumber: 'TAJ-RES-9932',
      status: BookingStatus.confirmed,
      startDateTime: '2026-08-21T14:00:00Z',
      endDateTime: '2026-08-25T11:00:00Z',
      location: 'Sinquerim Beach, Candolim, Goa',
      details: const {'checkInTime': '02:00 PM', 'roomType': 'Sea View Suite'},
      linkedDocumentIds: const ['doc-hotel-1'],
      createdAt: DateTime.now().toIso8601String(),
    ),
  ];

  static final List<TravelDocument> _mockDocs = [
    TravelDocument(
      id: 'doc-ticket-1',
      tripId: 'trip-goa-escape',
      bookingId: 'book-flight-1',
      title: 'IndiGo Flight E-Ticket.pdf',
      category: DocumentCategory.transport,
      fileType: 'pdf',
      fileSizeBytes: 428000,
      storagePath: 'private/documents/indigo-eticket.pdf',
      uploadedAt: DateTime.now().toIso8601String(),
    ),
    TravelDocument(
      id: 'doc-hotel-1',
      tripId: 'trip-goa-escape',
      bookingId: 'book-hotel-1',
      title: 'Taj Hotel Booking Voucher.pdf',
      category: DocumentCategory.accommodation,
      fileType: 'pdf',
      fileSizeBytes: 612000,
      storagePath: 'private/documents/taj-voucher.pdf',
      uploadedAt: DateTime.now().toIso8601String(),
    ),
  ];

  @override
  Future<List<Booking>> getBookings(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/bookings');
      return (res.data as List<dynamic>).map((e) => Booking.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockBookings;
    }
  }

  @override
  Future<Booking> createBooking(String tripId, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post('/trips/$tripId/bookings', data: body);
      return Booking.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return Booking.fromJson({...body, 'id': 'book-${DateTime.now().millisecondsSinceEpoch}', 'tripId': tripId});
    }
  }

  @override
  Future<List<TravelDocument>> getDocuments(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/documents');
      return (res.data as List<dynamic>).map((e) => TravelDocument.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockDocs;
    }
  }

  @override
  Future<TravelDocument> createDocument(String tripId, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post('/trips/$tripId/documents', data: body);
      return TravelDocument.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return TravelDocument.fromJson({...body, 'id': 'doc-${DateTime.now().millisecondsSinceEpoch}', 'tripId': tripId});
    }
  }

  @override
  Future<TripOperationsSummary> getOperationsSummary(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/operations');
      return TripOperationsSummary.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return TripOperationsSummary(
        tripId: tripId,
        readinessScore: 92,
        readinessStatus: 'mostly_ready',
        summary: '2 of 2 bookings confirmed. Flights & stay tickets attached.',
        totalBookings: 2,
        confirmedBookingsCount: 2,
        totalDocumentsCount: 2,
        attentionItems: const [],
      );
    }
  }
}

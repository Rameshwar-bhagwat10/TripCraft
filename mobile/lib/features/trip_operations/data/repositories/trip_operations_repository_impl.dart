import '../datasources/trip_operations_remote_datasource.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/travel_document.dart';

class TripOperationsRepositoryImpl {
  final TripOperationsRemoteDataSource _dataSource;

  TripOperationsRepositoryImpl(this._dataSource);

  Future<List<Booking>> getBookings(String tripId) => _dataSource.getBookings(tripId);
  Future<Booking> createBooking(String tripId, Map<String, dynamic> body) => _dataSource.createBooking(tripId, body);
  Future<List<TravelDocument>> getDocuments(String tripId) => _dataSource.getDocuments(tripId);
  Future<TravelDocument> createDocument(String tripId, Map<String, dynamic> body) => _dataSource.createDocument(tripId, body);
  Future<TripOperationsSummary> getOperationsSummary(String tripId) => _dataSource.getOperationsSummary(tripId);
}

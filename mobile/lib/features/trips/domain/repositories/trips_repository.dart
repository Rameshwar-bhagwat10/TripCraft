import '../entities/trip.dart';

abstract class TripsRepository {
  Future<Trip> createTrip(Map<String, dynamic> body);
  Future<List<Trip>> getTrips(TripFilter filter);
  Future<Trip> getTripById(String id);
  Future<Trip> updateTrip(String id, Map<String, dynamic> body);
  Future<Trip> archiveTrip(String id);
  Future<Trip> restoreTrip(String id);
  Future<bool> deleteTrip(String id);
}

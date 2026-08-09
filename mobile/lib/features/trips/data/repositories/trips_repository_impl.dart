import '../../domain/entities/trip.dart';
import '../../domain/repositories/trips_repository.dart';
import '../datasources/trips_remote_datasource.dart';

class TripsRepositoryImpl implements TripsRepository {
  final TripsRemoteDataSource _remoteDataSource;

  TripsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Trip> createTrip(Map<String, dynamic> body) {
    return _remoteDataSource.createTrip(body);
  }

  @override
  Future<List<Trip>> getTrips(TripFilter filter) {
    return _remoteDataSource.getTrips(filter);
  }

  @override
  Future<Trip> getTripById(String id) {
    return _remoteDataSource.getTripById(id);
  }

  @override
  Future<Trip> updateTrip(String id, Map<String, dynamic> body) {
    return _remoteDataSource.updateTrip(id, body);
  }

  @override
  Future<Trip> archiveTrip(String id) {
    return _remoteDataSource.archiveTrip(id);
  }

  @override
  Future<Trip> restoreTrip(String id) {
    return _remoteDataSource.restoreTrip(id);
  }

  @override
  Future<bool> deleteTrip(String id) {
    return _remoteDataSource.deleteTrip(id);
  }
}

import '../../domain/entities/itinerary.dart';
import '../../domain/repositories/itinerary_repository.dart';
import '../datasources/itinerary_remote_datasource.dart';

class ItineraryRepositoryImpl implements ItineraryRepository {
  final ItineraryRemoteDataSource _remoteDataSource;

  ItineraryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Itinerary> getItinerary(String tripId) {
    return _remoteDataSource.getItinerary(tripId);
  }

  @override
  Future<ItineraryItem> createItineraryItem(String tripId, String dayId, Map<String, dynamic> body) {
    return _remoteDataSource.createItineraryItem(tripId, dayId, body);
  }

  @override
  Future<ItineraryItem> updateItineraryItem(String tripId, String itemId, Map<String, dynamic> body) {
    return _remoteDataSource.updateItineraryItem(tripId, itemId, body);
  }

  @override
  Future<bool> deleteItineraryItem(String tripId, String itemId) {
    return _remoteDataSource.deleteItineraryItem(tripId, itemId);
  }

  @override
  Future<bool> reorderItineraryItems(String tripId, String dayId, List<Map<String, dynamic>> items) {
    return _remoteDataSource.reorderItineraryItems(tripId, dayId, items);
  }

  @override
  Future<ItineraryItem> moveItineraryItem(String tripId, String itemId, String targetDayId, int newOrderIndex) {
    return _remoteDataSource.moveItineraryItem(tripId, itemId, targetDayId, newOrderIndex);
  }

  @override
  Future<TripDay> updateTripDay(String tripId, String dayId, Map<String, dynamic> body) {
    return _remoteDataSource.updateTripDay(tripId, dayId, body);
  }
}

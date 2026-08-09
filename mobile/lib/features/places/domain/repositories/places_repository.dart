import '../entities/place.dart';

abstract class PlacesRepository {
  Future<List<Place>> searchPlaces({String? query, String? category});
  Future<Place> getPlaceDetails(String id);
  Future<bool> toggleSavePlace(String id);
}

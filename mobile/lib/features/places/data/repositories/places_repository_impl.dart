import '../../domain/entities/place.dart';
import '../../domain/repositories/places_repository.dart';
import '../datasources/places_remote_datasource.dart';

class PlacesRepositoryImpl implements PlacesRepository {
  final PlacesRemoteDataSource _remoteDataSource;

  PlacesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Place>> searchPlaces({String? query, String? category}) {
    return _remoteDataSource.searchPlaces(query: query, category: category);
  }

  @override
  Future<Place> getPlaceDetails(String id) {
    return _remoteDataSource.getPlaceDetails(id);
  }

  @override
  Future<bool> toggleSavePlace(String id) {
    return _remoteDataSource.toggleSavePlace(id);
  }
}

import '../datasources/memories_remote_datasource.dart';
import '../../domain/entities/trip_photo.dart';

class MemoriesRepositoryImpl {
  final MemoriesRemoteDataSource _dataSource;

  MemoriesRepositoryImpl(this._dataSource);

  Future<List<TripPhoto>> getPhotos(String tripId) => _dataSource.getPhotos(tripId);
  Future<TripPhoto> createPhoto(String tripId, Map<String, dynamic> body) => _dataSource.createPhoto(tripId, body);
  Future<TripPhoto> toggleFavorite(String photoId) => _dataSource.toggleFavorite(photoId);
  Future<void> deletePhoto(String photoId) => _dataSource.deletePhoto(photoId);
  Future<List<PhotoAlbum>> getAlbums(String tripId) => _dataSource.getAlbums(tripId);
  Future<PhotoAlbum> createAlbum(String tripId, Map<String, dynamic> body) => _dataSource.createAlbum(tripId, body);
  Future<List<MemoryTimelineDay>> getTimeline(String tripId) => _dataSource.getTimeline(tripId);
  Future<List<MemoryMapPoint>> getMapPoints(String tripId) => _dataSource.getMapPoints(tripId);
  Future<TripMemorySummary> getSummary(String tripId) => _dataSource.getSummary(tripId);
}

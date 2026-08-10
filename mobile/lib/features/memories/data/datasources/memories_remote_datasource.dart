import 'package:dio/dio.dart';
import '../../domain/entities/trip_photo.dart';

abstract class MemoriesRemoteDataSource {
  Future<List<TripPhoto>> getPhotos(String tripId);
  Future<TripPhoto> createPhoto(String tripId, Map<String, dynamic> body);
  Future<TripPhoto> toggleFavorite(String photoId);
  Future<void> deletePhoto(String photoId);
  Future<List<PhotoAlbum>> getAlbums(String tripId);
  Future<PhotoAlbum> createAlbum(String tripId, Map<String, dynamic> body);
  Future<List<MemoryTimelineDay>> getTimeline(String tripId);
  Future<List<MemoryMapPoint>> getMapPoints(String tripId);
  Future<TripMemorySummary> getSummary(String tripId);
}

class MemoriesRemoteDataSourceImpl implements MemoriesRemoteDataSource {
  final Dio _dio;

  MemoriesRemoteDataSourceImpl(this._dio);

  static final List<TripPhoto> _mockPhotos = [
    TripPhoto(
      id: 'photo-baga-sunset-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      storagePath: 'private/memories/baga-sunset-1.jpg',
      thumbnailPath: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400',
      previewPath: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
      fileName: 'baga-sunset-1.jpg',
      fileSizeBytes: 2450000,
      width: 3840,
      height: 2160,
      caption: 'Golden hour sunset at Baga Beach',
      latitude: 15.5551,
      longitude: 73.7512,
      locationName: 'Baga Beach, North Goa',
      takenAt: '2026-08-21T18:15:00Z',
      uploadedAt: DateTime.now().toIso8601String(),
      itineraryActivityId: 'item-1',
      placeId: 'place-baga-beach',
      tripDay: 1,
      isFavorite: true,
      albumIds: const ['album-sunsets-1'],
    ),
    TripPhoto(
      id: 'photo-fort-aguada-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      storagePath: 'private/memories/fort-aguada-1.jpg',
      thumbnailPath: 'https://images.unsplash.com/photo-1587922546307-776227941871?w=400',
      previewPath: 'https://images.unsplash.com/photo-1587922546307-776227941871?w=1200',
      fileName: 'fort-aguada-1.jpg',
      fileSizeBytes: 3100000,
      width: 4000,
      height: 3000,
      caption: 'Panoramics from Fort Aguada lighthouse',
      latitude: 15.4924,
      longitude: 73.7737,
      locationName: 'Fort Aguada, Candolim',
      takenAt: '2026-08-22T10:30:00Z',
      uploadedAt: DateTime.now().toIso8601String(),
      itineraryActivityId: 'item-2',
      placeId: 'place-fort-aguada',
      tripDay: 2,
      isFavorite: true,
      albumIds: const ['album-sightseeing-1'],
    ),
    TripPhoto(
      id: 'photo-thalassa-dinner-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      storagePath: 'private/memories/thalassa-1.jpg',
      thumbnailPath: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400',
      previewPath: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=1200',
      fileName: 'thalassa-1.jpg',
      fileSizeBytes: 1850000,
      width: 3024,
      height: 4032,
      caption: 'Greek dinner at Thalassa Vagator',
      latitude: 15.6022,
      longitude: 73.7335,
      locationName: 'Thalassa Restaurant, Vagator',
      takenAt: '2026-08-22T20:00:00Z',
      uploadedAt: DateTime.now().toIso8601String(),
      tripDay: 2,
      isFavorite: false,
      albumIds: const [],
    ),
  ];

  static final List<PhotoAlbum> _mockAlbums = [
    PhotoAlbum(
      id: 'album-sunsets-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      title: 'Beach Sunsets & Evenings',
      description: 'Golden hour pictures from Baga & Anjuna beach shacks',
      coverPhotoUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600',
      photoCount: 12,
      createdAt: DateTime.now().toIso8601String(),
    ),
    PhotoAlbum(
      id: 'album-sightseeing-1',
      tripId: 'trip-goa-escape',
      userId: 'user-rameshwar',
      title: 'Historic Forts & Architecture',
      description: 'Fort Aguada, Chapora & Old Goa Latin Quarter',
      coverPhotoUrl: 'https://images.unsplash.com/photo-1587922546307-776227941871?w=600',
      photoCount: 18,
      createdAt: DateTime.now().toIso8601String(),
    ),
  ];

  @override
  Future<List<TripPhoto>> getPhotos(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/photos');
      return (res.data as List<dynamic>).map((e) => TripPhoto.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockPhotos;
    }
  }

  @override
  Future<TripPhoto> createPhoto(String tripId, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post('/trips/$tripId/photos', data: body);
      return TripPhoto.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return TripPhoto.fromJson({
        ...body,
        'id': 'photo-${DateTime.now().millisecondsSinceEpoch}',
        'tripId': tripId,
        'storagePath': 'private/memories/photo.jpg',
        'thumbnailPath': body['thumbnailPath'] ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400',
        'previewPath': body['previewPath'] ?? 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=1200',
        'fileName': 'photo.jpg',
        'fileSizeBytes': 2500000,
        'width': 3840,
        'height': 2160,
        'takenAt': DateTime.now().toIso8601String(),
        'uploadedAt': DateTime.now().toIso8601String(),
      });
    }
  }

  @override
  Future<TripPhoto> toggleFavorite(String photoId) async {
    try {
      final res = await _dio.post('/photos/$photoId/favorite');
      return TripPhoto.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      final found = _mockPhotos.firstWhere((p) => p.id == photoId, orElse: () => _mockPhotos[0]);
      return TripPhoto(
        id: found.id,
        tripId: found.tripId,
        userId: found.userId,
        storagePath: found.storagePath,
        thumbnailPath: found.thumbnailPath,
        previewPath: found.previewPath,
        fileName: found.fileName,
        fileSizeBytes: found.fileSizeBytes,
        width: found.width,
        height: found.height,
        caption: found.caption,
        takenAt: found.takenAt,
        uploadedAt: found.uploadedAt,
        isFavorite: !found.isFavorite,
      );
    }
  }

  @override
  Future<void> deletePhoto(String photoId) async {
    try {
      await _dio.delete('/photos/$photoId');
    } catch (_) {}
  }

  @override
  Future<List<PhotoAlbum>> getAlbums(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/albums');
      return (res.data as List<dynamic>).map((e) => PhotoAlbum.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockAlbums;
    }
  }

  @override
  Future<PhotoAlbum> createAlbum(String tripId, Map<String, dynamic> body) async {
    try {
      final res = await _dio.post('/trips/$tripId/albums', data: body);
      return PhotoAlbum.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return PhotoAlbum.fromJson({
        ...body,
        'id': 'album-${DateTime.now().millisecondsSinceEpoch}',
        'tripId': tripId,
        'coverPhotoUrl': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600',
        'photoCount': 0,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }
  }

  @override
  Future<List<MemoryTimelineDay>> getTimeline(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/memories/timeline');
      return (res.data as List<dynamic>).map((e) => MemoryTimelineDay.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [
        MemoryTimelineDay(dayNumber: 1, dateTitle: 'Aug 21, 2026', locationTitle: 'Baga Beach & Sunset Coast', photos: [_mockPhotos[0]]),
        MemoryTimelineDay(dayNumber: 2, dateTitle: 'Aug 22, 2026', locationTitle: 'Fort Aguada & Vagator', photos: [_mockPhotos[1], _mockPhotos[2]]),
      ];
    }
  }

  @override
  Future<List<MemoryMapPoint>> getMapPoints(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/memories/map');
      return (res.data as List<dynamic>).map((e) => MemoryMapPoint.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return const [
        MemoryMapPoint(id: 'pt-1', locationName: 'Baga Beach', latitude: 15.5551, longitude: 73.7512, photoCount: 1, coverPhotoUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400'),
        MemoryMapPoint(id: 'pt-2', locationName: 'Fort Aguada', latitude: 15.4924, longitude: 73.7737, photoCount: 1, coverPhotoUrl: 'https://images.unsplash.com/photo-1587922546307-776227941871?w=400'),
      ];
    }
  }

  @override
  Future<TripMemorySummary> getSummary(String tripId) async {
    try {
      final res = await _dio.get('/trips/$tripId/memories/summary');
      return TripMemorySummary.fromJson(res.data as Map<String, dynamic>);
    } catch (_) {
      return TripMemorySummary(
        tripId: tripId,
        totalPhotosCount: 3,
        totalAlbumsCount: 2,
        totalPlacesPhotographed: 3,
        favoritePhotosCount: 2,
        mostPhotographedPlace: 'Baga Beach',
        mostActiveDayNumber: 2,
      );
    }
  }
}

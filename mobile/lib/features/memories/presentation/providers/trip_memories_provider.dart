import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/datasources/memories_remote_datasource.dart';
import '../../data/repositories/memories_repository_impl.dart';
import '../../domain/entities/trip_photo.dart';

class TripMemoriesState {
  final bool isLoading;
  final TripMemorySummary? summary;
  final List<TripPhoto> photos;
  final List<PhotoAlbum> albums;
  final List<MemoryTimelineDay> timelineDays;
  final List<MemoryMapPoint> mapPoints;
  final String activeSegment; // 'photos', 'albums', 'timeline', 'map'
  final String? errorMessage;

  const TripMemoriesState({
    this.isLoading = false,
    this.summary,
    this.photos = const [],
    this.albums = const [],
    this.timelineDays = const [],
    this.mapPoints = const [],
    this.activeSegment = 'photos',
    this.errorMessage,
  });

  TripMemoriesState copyWith({
    bool? isLoading,
    TripMemorySummary? summary,
    List<TripPhoto>? photos,
    List<PhotoAlbum>? albums,
    List<MemoryTimelineDay>? timelineDays,
    List<MemoryMapPoint>? mapPoints,
    String? activeSegment,
    String? errorMessage,
  }) {
    return TripMemoriesState(
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      photos: photos ?? this.photos,
      albums: albums ?? this.albums,
      timelineDays: timelineDays ?? this.timelineDays,
      mapPoints: mapPoints ?? this.mapPoints,
      activeSegment: activeSegment ?? this.activeSegment,
      errorMessage: errorMessage,
    );
  }
}

final memoriesRepositoryProvider = Provider<MemoriesRepositoryImpl>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final ds = MemoriesRemoteDataSourceImpl(apiClient.client);
  return MemoriesRepositoryImpl(ds);
});

class TripMemoriesNotifier extends StateNotifier<TripMemoriesState> {
  final MemoriesRepositoryImpl _repository;
  final String tripId;

  TripMemoriesNotifier(this._repository, this.tripId) : super(const TripMemoriesState()) {
    loadMemoriesData();
  }

  Future<void> loadMemoriesData() async {
    state = state.copyWith(isLoading: true);
    try {
      final [summary, photos, albums, timeline, mapPoints] = await Future.wait([
        _repository.getSummary(tripId),
        _repository.getPhotos(tripId),
        _repository.getAlbums(tripId),
        _repository.getTimeline(tripId),
        _repository.getMapPoints(tripId),
      ]);

      state = state.copyWith(
        isLoading: false,
        summary: summary as TripMemorySummary,
        photos: photos as List<TripPhoto>,
        albums: albums as List<PhotoAlbum>,
        timelineDays: timeline as List<MemoryTimelineDay>,
        mapPoints: mapPoints as List<MemoryMapPoint>,
      );
    } catch (_) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load trip memories.');
    }
  }

  void setActiveSegment(String segment) {
    state = state.copyWith(activeSegment: segment);
  }

  Future<void> createPhoto(Map<String, dynamic> body) async {
    final newPhoto = await _repository.createPhoto(tripId, body);
    state = state.copyWith(photos: [newPhoto, ...state.photos]);
    loadMemoriesData();
  }

  Future<void> toggleFavorite(String photoId) async {
    final updated = await _repository.toggleFavorite(photoId);
    final updatedPhotos = state.photos.map((p) => p.id == photoId ? updated : p).toList();
    state = state.copyWith(photos: updatedPhotos);
  }

  Future<void> deletePhoto(String photoId) async {
    await _repository.deletePhoto(photoId);
    state = state.copyWith(photos: state.photos.where((p) => p.id != photoId).toList());
    loadMemoriesData();
  }

  Future<void> createAlbum(Map<String, dynamic> body) async {
    final newAlbum = await _repository.createAlbum(tripId, body);
    state = state.copyWith(albums: [...state.albums, newAlbum]);
    loadMemoriesData();
  }
}

final tripMemoriesProvider = StateNotifierProvider.family<TripMemoriesNotifier, TripMemoriesState, String>((ref, tripId) {
  final repo = ref.watch(memoriesRepositoryProvider);
  return TripMemoriesNotifier(repo, tripId);
});

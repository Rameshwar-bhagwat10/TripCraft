import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/memories/data/repositories/memories_repository_impl.dart';
import 'package:tripcraft/features/memories/domain/entities/trip_photo.dart';
import 'package:tripcraft/features/memories/presentation/providers/trip_memories_provider.dart';
import 'package:tripcraft/features/memories/presentation/screens/memories_overview_screen.dart';

class FakeMemoriesRepository implements MemoriesRepositoryImpl {
  @override
  Future<List<TripPhoto>> getPhotos(String tripId) async {
    return [
      TripPhoto(
        id: 'photo-1',
        tripId: tripId,
        userId: 'user-1',
        storagePath: 'path.jpg',
        thumbnailPath: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400',
        previewPath: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
        fileName: 'photo.jpg',
        fileSizeBytes: 2000000,
        width: 3000,
        height: 2000,
        caption: 'Baga Sunset',
        takenAt: DateTime.now().toIso8601String(),
        uploadedAt: DateTime.now().toIso8601String(),
        isFavorite: true,
      ),
    ];
  }

  @override
  Future<List<PhotoAlbum>> getAlbums(String tripId) async {
    return [
      PhotoAlbum(
        id: 'album-1',
        tripId: tripId,
        userId: 'user-1',
        title: 'Beach Sunsets',
        description: 'Golden hour',
        coverPhotoUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600',
        photoCount: 5,
        createdAt: DateTime.now().toIso8601String(),
      ),
    ];
  }

  @override
  Future<List<MemoryTimelineDay>> getTimeline(String tripId) async => [];

  @override
  Future<List<MemoryMapPoint>> getMapPoints(String tripId) async => [];

  @override
  Future<TripMemorySummary> getSummary(String tripId) async {
    return TripMemorySummary(
      tripId: tripId,
      totalPhotosCount: 1,
      totalAlbumsCount: 1,
      totalPlacesPhotographed: 1,
      favoritePhotosCount: 1,
      mostPhotographedPlace: 'Baga Beach',
      mostActiveDayNumber: 1,
    );
  }

  @override
  Future<TripPhoto> createPhoto(String tripId, Map<String, dynamic> body) async {
    return (await getPhotos(tripId))[0];
  }

  @override
  Future<PhotoAlbum> createAlbum(String tripId, Map<String, dynamic> body) async {
    return (await getAlbums(tripId))[0];
  }

  @override
  Future<TripPhoto> toggleFavorite(String photoId) async {
    return (await getPhotos('trip-1'))[0];
  }

  @override
  Future<void> deletePhoto(String photoId) async {}
}

void main() {
  testWidgets('MemoriesOverviewScreen renders story metrics and segment chips', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          memoriesRepositoryProvider.overrideWithValue(FakeMemoriesRepository()),
        ],
        child: const MaterialApp(
          home: MemoriesOverviewScreen(tripId: 'test-trip-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Trip Memories & Story'), findsOneWidget);
    expect(find.text('TRIP STORY METRICS'), findsOneWidget);
    expect(find.text('Photos'), findsWidgets);
    expect(find.text('Albums'), findsWidgets);
    expect(find.text('Timeline'), findsOneWidget);
    expect(find.text('Map View'), findsOneWidget);
  });
}

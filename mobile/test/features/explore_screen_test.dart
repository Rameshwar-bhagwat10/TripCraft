import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/explore/domain/entities/destination.dart';
import 'package:tripcraft/features/explore/domain/repositories/explore_repository.dart';
import 'package:tripcraft/features/explore/presentation/providers/explore_provider.dart';
import 'package:tripcraft/features/explore/presentation/screens/explore_screen.dart';

class DummyExploreRepository implements ExploreRepository {
  static const mockDest = Destination(
    id: 'dest-goa',
    name: 'Goa',
    slug: 'goa',
    city: 'Goa',
    country: 'India',
    region: 'South Asia',
    description: 'Beach paradise',
    heroImage: '',
    rating: 4.8,
    reviewCount: 340,
    isFeatured: true,
    isTrending: true,
  );

  @override
  Future<List<Destination>> getDestinations(DestinationFilter filter) async => [mockDest];

  @override
  Future<List<Destination>> getFeaturedDestinations() async => [mockDest];

  @override
  Future<List<Destination>> getRecommendedDestinations() async => [mockDest];

  @override
  Future<List<Destination>> getTrendingDestinations() async => [mockDest];

  @override
  Future<Destination> getDestinationById(String id) async => mockDest;

  @override
  Future<bool> saveDestination(String id) async => true;

  @override
  Future<bool> unsaveDestination(String id) async => false;

  @override
  Future<List<Destination>> getSavedDestinations() async => [mockDest];
}

void main() {
  testWidgets('ExploreScreen renders header, search bar, categories and featured card', (WidgetTester tester) async {
    const mockDest = Destination(
      id: 'dest-goa',
      name: 'Goa',
      slug: 'goa',
      city: 'Goa',
      country: 'India',
      region: 'South Asia',
      description: 'Beach paradise',
      heroImage: '',
      rating: 4.8,
      reviewCount: 340,
      isFeatured: true,
      isTrending: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          exploreRepositoryProvider.overrideWithValue(DummyExploreRepository()),
          exploreProvider.overrideWith((ref) {
            return ExploreNotifier(
              DummyExploreRepository(),
              const ExploreState(
                featured: [mockDest],
                recommended: [mockDest],
                trending: [mockDest],
              ),
            );
          }),
        ],
        child: const MaterialApp(
          home: ExploreScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Explore'), findsWidgets);
    expect(find.text('Search destinations, cities, activities...'), findsOneWidget);
    expect(find.text('Beach'), findsOneWidget);
    expect(find.text('Mountains'), findsOneWidget);
    expect(find.text('FEATURED DESTINATIONS'), findsOneWidget);
    expect(find.text('Goa'), findsWidgets);
  });
}

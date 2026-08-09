import '../entities/destination.dart';

abstract class ExploreRepository {
  Future<List<Destination>> getDestinations(DestinationFilter filter);
  Future<List<Destination>> getFeaturedDestinations();
  Future<List<Destination>> getRecommendedDestinations();
  Future<List<Destination>> getTrendingDestinations();
  Future<Destination> getDestinationById(String id);
  Future<bool> saveDestination(String id);
  Future<bool> unsaveDestination(String id);
  Future<List<Destination>> getSavedDestinations();
}

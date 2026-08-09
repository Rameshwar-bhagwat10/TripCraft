import '../../domain/entities/destination.dart';
import '../../domain/repositories/explore_repository.dart';
import '../datasources/explore_remote_datasource.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  final ExploreRemoteDataSource _remoteDataSource;

  ExploreRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Destination>> getDestinations(DestinationFilter filter) {
    return _remoteDataSource.getDestinations(filter);
  }

  @override
  Future<List<Destination>> getFeaturedDestinations() {
    return _remoteDataSource.getFeaturedDestinations();
  }

  @override
  Future<List<Destination>> getRecommendedDestinations() {
    return _remoteDataSource.getRecommendedDestinations();
  }

  @override
  Future<List<Destination>> getTrendingDestinations() {
    return _remoteDataSource.getTrendingDestinations();
  }

  @override
  Future<Destination> getDestinationById(String id) {
    return _remoteDataSource.getDestinationById(id);
  }

  @override
  Future<bool> saveDestination(String id) {
    return _remoteDataSource.saveDestination(id);
  }

  @override
  Future<bool> unsaveDestination(String id) {
    return _remoteDataSource.unsaveDestination(id);
  }

  @override
  Future<List<Destination>> getSavedDestinations() {
    return _remoteDataSource.getSavedDestinations();
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/datasources/explore_remote_datasource.dart';
import '../../data/repositories/explore_repository_impl.dart';
import '../../domain/entities/destination.dart';
import '../../domain/repositories/explore_repository.dart';

class ExploreState {
  final bool isLoading;
  final bool isRefreshing;
  final DestinationFilter filter;
  final List<Destination> featured;
  final List<Destination> recommended;
  final List<Destination> trending;
  final List<Destination> filteredDestinations;
  final String? selectedCategory;
  final String? errorMessage;

  const ExploreState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.filter = const DestinationFilter(),
    this.featured = const [],
    this.recommended = const [],
    this.trending = const [],
    this.filteredDestinations = const [],
    this.selectedCategory,
    this.errorMessage,
  });

  ExploreState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    DestinationFilter? filter,
    List<Destination>? featured,
    List<Destination>? recommended,
    List<Destination>? trending,
    List<Destination>? filteredDestinations,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return ExploreState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      filter: filter ?? this.filter,
      featured: featured ?? this.featured,
      recommended: recommended ?? this.recommended,
      trending: trending ?? this.trending,
      filteredDestinations: filteredDestinations ?? this.filteredDestinations,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage,
    );
  }
}

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final dataSource = ExploreRemoteDataSourceImpl(apiClient.client);
  return ExploreRepositoryImpl(dataSource);
});

class ExploreNotifier extends StateNotifier<ExploreState> {
  final ExploreRepository _repository;

  ExploreNotifier(this._repository, [ExploreState? initialState])
      : super(initialState ?? const ExploreState()) {
    if (initialState == null) {
      loadExploreData();
    }
  }

  Future<void> loadExploreData({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isRefreshing: true, errorMessage: null);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final featured = await _repository.getFeaturedDestinations();
      final recommended = await _repository.getRecommendedDestinations();
      final trending = await _repository.getTrendingDestinations();
      final filtered = await _repository.getDestinations(state.filter);

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        featured: featured,
        recommended: recommended,
        trending: trending,
        filteredDestinations: filtered,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: 'Unable to load explore destinations. Please try again.',
      );
    }
  }

  Future<void> selectCategory(String? category) async {
    final newCategory = (state.selectedCategory == category) ? null : category;
    final updatedFilter = state.filter.copyWith(category: newCategory);
    state = state.copyWith(
      selectedCategory: newCategory,
      filter: updatedFilter,
      isLoading: true,
    );

    try {
      final filtered = await _repository.getDestinations(updatedFilter);
      state = state.copyWith(isLoading: false, filteredDestinations: filtered);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> updateFilter(DestinationFilter newFilter) async {
    state = state.copyWith(filter: newFilter, isLoading: true);
    try {
      final filtered = await _repository.getDestinations(newFilter);
      state = state.copyWith(isLoading: false, filteredDestinations: filtered);
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> toggleSaveDestination(String destId) async {
    bool isCurrentlySaved = false;
    final dest = state.featured.firstWhere(
      (d) => d.id == destId,
      orElse: () => state.recommended.firstWhere(
        (d) => d.id == destId,
        orElse: () => state.filteredDestinations.firstWhere(
          (d) => d.id == destId,
          orElse: () => state.trending.firstWhere(
            (d) => d.id == destId,
            orElse: () => const Destination(id: '', name: '', slug: '', city: '', country: '', region: '', description: '', heroImage: ''),
          ),
        ),
      ),
    );

    isCurrentlySaved = dest.isSaved;
    final newSavedStatus = !isCurrentlySaved;

    // Optimistic UI update
    List<Destination> updateList(List<Destination> list) {
      return list.map((d) => d.id == destId ? d.copyWith(isSaved: newSavedStatus) : d).toList();
    }

    state = state.copyWith(
      featured: updateList(state.featured),
      recommended: updateList(state.recommended),
      trending: updateList(state.trending),
      filteredDestinations: updateList(state.filteredDestinations),
    );

    try {
      if (newSavedStatus) {
        await _repository.saveDestination(destId);
      } else {
        await _repository.unsaveDestination(destId);
      }
    } catch (_) {
      // Revert if API fails
      state = state.copyWith(
        featured: updateList(state.featured),
        recommended: updateList(state.recommended),
        trending: updateList(state.trending),
        filteredDestinations: updateList(state.filteredDestinations),
      );
    }
  }
}

final exploreProvider = StateNotifierProvider<ExploreNotifier, ExploreState>((ref) {
  final repository = ref.watch(exploreRepositoryProvider);
  return ExploreNotifier(repository);
});

final destinationDetailsProvider = FutureProvider.family<Destination, String>((ref, id) async {
  final repository = ref.watch(exploreRepositoryProvider);
  return repository.getDestinationById(id);
});

final savedDestinationsProvider = FutureProvider<List<Destination>>((ref) async {
  final repository = ref.watch(exploreRepositoryProvider);
  return repository.getSavedDestinations();
});
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/datasources/places_remote_datasource.dart';
import '../../data/repositories/places_repository_impl.dart';
import '../../domain/entities/place.dart';
import '../../domain/repositories/places_repository.dart';

class PlacesState {
  final bool isLoading;
  final List<Place> places;
  final PlaceCategory selectedCategory;
  final String searchQuery;
  final String? errorMessage;

  const PlacesState({
    this.isLoading = false,
    this.places = const [],
    this.selectedCategory = PlaceCategory.all,
    this.searchQuery = '',
    this.errorMessage,
  });

  PlacesState copyWith({
    bool? isLoading,
    List<Place>? places,
    PlaceCategory? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return PlacesState(
      isLoading: isLoading ?? this.isLoading,
      places: places ?? this.places,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }
}

final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final dataSource = PlacesRemoteDataSourceImpl(apiClient.client);
  return PlacesRepositoryImpl(dataSource);
});

class PlacesNotifier extends StateNotifier<PlacesState> {
  final PlacesRepository _repository;

  PlacesNotifier(this._repository) : super(const PlacesState()) {
    fetchPlaces();
  }

  Future<void> fetchPlaces({String? query, PlaceCategory? category}) async {
    state = state.copyWith(
      isLoading: true,
      searchQuery: query ?? state.searchQuery,
      selectedCategory: category ?? state.selectedCategory,
      errorMessage: null,
    );

    try {
      final list = await _repository.searchPlaces(
        query: state.searchQuery,
        category: state.selectedCategory == PlaceCategory.all ? null : state.selectedCategory.name,
      );
      state = state.copyWith(isLoading: false, places: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to search places');
    }
  }

  void selectCategory(PlaceCategory category) {
    fetchPlaces(category: category);
  }

  void setSearchQuery(String query) {
    fetchPlaces(query: query);
  }

  Future<void> toggleSave(String placeId) async {
    final updatedList = state.places.map((p) {
      if (p.id == placeId) {
        return p.copyWith(isSaved: !p.isSaved);
      }
      return p;
    }).toList();

    state = state.copyWith(places: updatedList);
    await _repository.toggleSavePlace(placeId);
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, PlacesState>((ref) {
  final repo = ref.watch(placesRepositoryProvider);
  return PlacesNotifier(repo);
});

final placeDetailsProvider = FutureProvider.family<Place, String>((ref, placeId) async {
  final repo = ref.watch(placesRepositoryProvider);
  return repo.getPlaceDetails(placeId);
});

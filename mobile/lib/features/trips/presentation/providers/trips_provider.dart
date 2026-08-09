import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/datasources/trips_remote_datasource.dart';
import '../../data/repositories/trips_repository_impl.dart';
import '../../domain/entities/trip.dart';
import '../../domain/repositories/trips_repository.dart';

class TripsState {
  final bool isLoading;
  final bool isRefreshing;
  final int selectedTab; // 0: Upcoming, 1: Past, 2: Archived
  final List<Trip> trips;
  final String? errorMessage;

  const TripsState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.selectedTab = 0,
    this.trips = const [],
    this.errorMessage,
  });

  List<Trip> get upcomingTrips => trips
      .where((t) => t.status == TripStatus.upcoming || t.status == TripStatus.ongoing || t.status == TripStatus.draft)
      .toList();

  List<Trip> get pastTrips => trips.where((t) => t.status == TripStatus.completed).toList();

  List<Trip> get archivedTrips => trips.where((t) => t.status == TripStatus.archived).toList();

  Trip? get primaryUpcomingTrip {
    final list = upcomingTrips;
    return list.isNotEmpty ? list.first : null;
  }

  TripsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    int? selectedTab,
    List<Trip>? trips,
    String? errorMessage,
  }) {
    return TripsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      selectedTab: selectedTab ?? this.selectedTab,
      trips: trips ?? this.trips,
      errorMessage: errorMessage,
    );
  }
}

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final dataSource = TripsRemoteDataSourceImpl(apiClient.client);
  return TripsRepositoryImpl(dataSource);
});

class TripsNotifier extends StateNotifier<TripsState> {
  final TripsRepository _repository;

  TripsNotifier(this._repository, [TripsState? initialState])
      : super(initialState ?? const TripsState()) {
    if (initialState == null) {
      loadTrips();
    }
  }

  Future<void> loadTrips({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isRefreshing: true, errorMessage: null);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final trips = await _repository.getTrips(const TripFilter());
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        trips: trips,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: 'Unable to load trips. Please check your connection.',
      );
    }
  }

  void setSelectedTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  Future<Trip?> createTrip(Map<String, dynamic> body) async {
    try {
      final created = await _repository.createTrip(body);
      state = state.copyWith(trips: [created, ...state.trips]);
      return created;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to create trip.');
      return null;
    }
  }

  Future<bool> updateTrip(String id, Map<String, dynamic> body) async {
    try {
      final updated = await _repository.updateTrip(id, body);
      state = state.copyWith(
        trips: state.trips.map((t) => t.id == id ? updated : t).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to update trip.');
      return false;
    }
  }

  Future<bool> archiveTrip(String id) async {
    try {
      final archived = await _repository.archiveTrip(id);
      state = state.copyWith(
        trips: state.trips.map((t) => t.id == id ? archived : t).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restoreTrip(String id) async {
    try {
      final restored = await _repository.restoreTrip(id);
      state = state.copyWith(
        trips: state.trips.map((t) => t.id == id ? restored : t).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteTrip(String id) async {
    try {
      await _repository.deleteTrip(id);
      state = state.copyWith(
        trips: state.trips.where((t) => t.id != id).toList(),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}

final tripsProvider = StateNotifierProvider<TripsNotifier, TripsState>((ref) {
  final repository = ref.watch(tripsRepositoryProvider);
  return TripsNotifier(repository);
});

final tripDetailsProvider = FutureProvider.family<Trip, String>((ref, id) async {
  final repository = ref.watch(tripsRepositoryProvider);
  return repository.getTripById(id);
});
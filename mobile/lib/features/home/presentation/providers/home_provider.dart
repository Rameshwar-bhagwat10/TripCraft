import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../../trips/presentation/providers/trips_provider.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/entities/home_data.dart';
import '../../domain/repositories/home_repository.dart';

class HomeState {
  final bool isLoading;
  final bool isRefreshing;
  final HomeData data;
  final String? errorMessage;

  const HomeState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.data = const HomeData(),
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    HomeData? data,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      data: data ?? this.data,
      errorMessage: errorMessage,
    );
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final dataSource = HomeRemoteDataSourceImpl(apiClient.client);
  return HomeRepositoryImpl(dataSource);
});

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repository;

  HomeNotifier(this._repository, [HomeState? initialState])
      : super(initialState ?? const HomeState()) {
    if (initialState == null) {
      fetchHomeData();
    }
  }

  Future<void> fetchHomeData({bool isRefresh = false}) async {
    if (isRefresh) {
      state = state.copyWith(isRefreshing: true, errorMessage: null);
    } else {
      state = state.copyWith(isLoading: true, errorMessage: null);
    }

    try {
      final homeData = await _repository.getHomeData();
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        data: homeData,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: 'Unable to refresh home recommendations. Check your connection.',
      );
    }
  }

  void updateUpcomingTrip(UpcomingTrip? tripData) {
    state = state.copyWith(
      data: HomeData(
        upcomingTrip: tripData,
        recommendations: state.data.recommendations,
        inspiration: state.data.inspiration,
        weather: state.data.weather,
        recentActivity: state.data.recentActivity,
      ),
    );
  }

  void toggleSaveDestination(String recId) {
    final updatedRecs = state.data.recommendations.map((rec) {
      if (rec.id == recId) {
        return rec.copyWith(isSaved: !rec.isSaved);
      }
      return rec;
    }).toList();

    state = state.copyWith(
      data: HomeData(
        upcomingTrip: state.data.upcomingTrip,
        recommendations: updatedRecs,
        inspiration: state.data.inspiration,
        weather: state.data.weather,
        recentActivity: state.data.recentActivity,
      ),
    );
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  final notifier = HomeNotifier(repository);

  // Synchronize top upcoming trip from tripsProvider
  ref.listen<TripsState>(tripsProvider, (prev, next) {
    final primary = next.primaryUpcomingTrip;
    if (primary != null) {
      notifier.updateUpcomingTrip(
        UpcomingTrip(
          id: primary.id,
          destination: primary.title,
          location: primary.destination != null
              ? '${primary.destination!.city}, ${primary.destination!.country}'
              : primary.title,
          startDate: primary.startDate,
          endDate: primary.endDate,
          daysToGo: primary.daysToGo,
          imageUrl: primary.coverImage,
        ),
      );
    } else {
      notifier.updateUpcomingTrip(null);
    }
  });

  return notifier;
});
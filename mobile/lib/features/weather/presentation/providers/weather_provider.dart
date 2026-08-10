import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/app_providers.dart';
import '../../data/repositories/weather_repository_impl.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../../domain/providers/weather_provider_interface.dart';

class WeatherState {
  final bool isLoading;
  final WeatherSnapshot? current;
  final List<HourlyForecast> hourly;
  final List<DailyForecast> daily;
  final List<WeatherAlert> alerts;
  final String? errorMessage;

  const WeatherState({
    this.isLoading = false,
    this.current,
    this.hourly = const [],
    this.daily = const [],
    this.alerts = const [],
    this.errorMessage,
  });

  WeatherState copyWith({
    bool? isLoading,
    WeatherSnapshot? current,
    List<HourlyForecast>? hourly,
    List<DailyForecast>? daily,
    List<WeatherAlert>? alerts,
    String? errorMessage,
  }) {
    return WeatherState(
      isLoading: isLoading ?? this.isLoading,
      current: current ?? this.current,
      hourly: hourly ?? this.hourly,
      daily: daily ?? this.daily,
      alerts: alerts ?? this.alerts,
      errorMessage: errorMessage,
    );
  }
}

final weatherRepositoryProvider = Provider<WeatherProviderInterface>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return WeatherRepositoryImpl(apiClient.client);
});

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherProviderInterface _repository;
  final double lat;
  final double lng;

  WeatherNotifier(this._repository, this.lat, this.lng) : super(const WeatherState()) {
    loadWeather();
  }

  Future<void> loadWeather() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final current = await _repository.getCurrentWeather(lat, lng);
      final hourly = await _repository.getHourlyForecast(lat, lng);
      final daily = await _repository.getDailyForecast(lat, lng);
      final alerts = await _repository.getWeatherAlerts(lat, lng);

      state = state.copyWith(
        isLoading: false,
        current: current,
        hourly: hourly,
        daily: daily,
        alerts: alerts,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load weather forecast');
    }
  }
}

final weatherProvider = StateNotifierProvider.family<WeatherNotifier, WeatherState, String>((ref, key) {
  final parts = key.split(',');
  final lat = parts.isNotEmpty ? double.tryParse(parts[0]) ?? 15.4989 : 15.4989;
  final lng = parts.length > 1 ? double.tryParse(parts[1]) ?? 73.7725 : 73.7725;
  final repo = ref.watch(weatherRepositoryProvider);
  return WeatherNotifier(repo, lat, lng);
});

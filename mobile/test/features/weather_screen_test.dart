import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tripcraft/features/weather/domain/entities/weather_snapshot.dart';
import 'package:tripcraft/features/weather/domain/providers/weather_provider_interface.dart';
import 'package:tripcraft/features/weather/presentation/providers/weather_provider.dart';
import 'package:tripcraft/features/weather/presentation/screens/trip_weather_screen.dart';

class FakeWeatherRepository implements WeatherProviderInterface {
  @override
  Future<WeatherSnapshot> getCurrentWeather(double lat, double lng, {String? location}) async {
    return const WeatherSnapshot(
      location: 'Goa, India',
      latitude: 15.4989,
      longitude: 73.7725,
      temperature: 28,
      feelsLike: 31,
      tempMin: 24,
      tempMax: 30,
      condition: WeatherConditionType.partlyCloudy,
      conditionDescription: 'Partly cloudy',
      humidity: 74,
      windSpeed: 14,
      precipitationProbability: 35,
      observedAt: '2026-08-10T10:00:00Z',
    );
  }

  @override
  Future<List<HourlyForecast>> getHourlyForecast(double lat, double lng) async {
    return const [
      HourlyForecast(
        time: '09:00 AM',
        temperature: 27,
        feelsLike: 29,
        condition: WeatherConditionType.clear,
        precipitationProbability: 10,
        precipitationAmountMm: 0.0,
      ),
    ];
  }

  @override
  Future<List<DailyForecast>> getDailyForecast(double lat, double lng) async {
    return const [
      DailyForecast(
        date: '2026-08-21',
        dayName: 'Mon',
        tempMax: 30,
        tempMin: 24,
        condition: WeatherConditionType.partlyCloudy,
        precipitationProbability: 30,
        sunrise: '06:12 AM',
        sunset: '06:45 PM',
      ),
    ];
  }

  @override
  Future<List<WeatherAlert>> getWeatherAlerts(double lat, double lng) async {
    return const [];
  }
}

void main() {
  testWidgets('TripWeatherScreen renders hero weather card, hourly forecast timeline and daily forecast tiles', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          weatherRepositoryProvider.overrideWithValue(FakeWeatherRepository()),
        ],
        child: const MaterialApp(
          home: TripWeatherScreen(tripId: 'test-trip-1'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Trip Weather Forecast'), findsOneWidget);
    expect(find.text('HOURLY FORECAST'), findsOneWidget);
    expect(find.text('5-DAY DESTINATION FORECAST'), findsOneWidget);
  });
}

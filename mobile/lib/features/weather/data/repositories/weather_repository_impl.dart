import 'package:dio/dio.dart';
import '../../domain/entities/weather_snapshot.dart';
import '../../domain/providers/weather_provider_interface.dart';

class WeatherRepositoryImpl implements WeatherProviderInterface {
  final Dio _dio;

  WeatherRepositoryImpl(this._dio);

  static const WeatherSnapshot _mockSnapshot = WeatherSnapshot(
    location: 'Goa, India',
    latitude: 15.4989,
    longitude: 73.7725,
    temperature: 28,
    feelsLike: 31,
    tempMin: 24,
    tempMax: 30,
    condition: WeatherConditionType.partlyCloudy,
    conditionDescription: 'Partly cloudy with light coastal breeze',
    humidity: 74,
    windSpeed: 14,
    precipitationProbability: 35,
    uvIndex: 7,
    sunrise: '06:12 AM',
    sunset: '06:45 PM',
    observedAt: '2026-08-10T10:00:00Z',
  );

  static const List<HourlyForecast> _mockHourly = [
    HourlyForecast(time: '09:00 AM', temperature: 27, feelsLike: 29, condition: WeatherConditionType.clear, precipitationProbability: 10, precipitationAmountMm: 0.0),
    HourlyForecast(time: '11:00 AM', temperature: 29, feelsLike: 32, condition: WeatherConditionType.partlyCloudy, precipitationProbability: 20, precipitationAmountMm: 0.0),
    HourlyForecast(time: '01:00 PM', temperature: 30, feelsLike: 34, condition: WeatherConditionType.cloudy, precipitationProbability: 45, precipitationAmountMm: 0.5),
    HourlyForecast(time: '03:00 PM', temperature: 27, feelsLike: 30, condition: WeatherConditionType.heavyRain, precipitationProbability: 85, precipitationAmountMm: 12.4),
    HourlyForecast(time: '05:00 PM', temperature: 26, feelsLike: 28, condition: WeatherConditionType.rain, precipitationProbability: 60, precipitationAmountMm: 3.2),
    HourlyForecast(time: '07:00 PM', temperature: 25, feelsLike: 27, condition: WeatherConditionType.clear, precipitationProbability: 15, precipitationAmountMm: 0.0),
  ];

  static const List<DailyForecast> _mockDaily = [
    DailyForecast(date: '2026-08-21', dayName: 'Mon', tempMax: 30, tempMin: 24, condition: WeatherConditionType.partlyCloudy, precipitationProbability: 30, sunrise: '06:12 AM', sunset: '06:45 PM'),
    DailyForecast(date: '2026-08-22', dayName: 'Tue', tempMax: 27, tempMin: 23, condition: WeatherConditionType.heavyRain, precipitationProbability: 85, sunrise: '06:13 AM', sunset: '06:44 PM'),
    DailyForecast(date: '2026-08-23', dayName: 'Wed', tempMax: 29, tempMin: 24, condition: WeatherConditionType.cloudy, precipitationProbability: 40, sunrise: '06:13 AM', sunset: '06:44 PM'),
    DailyForecast(date: '2026-08-24', dayName: 'Thu', tempMax: 31, tempMin: 25, condition: WeatherConditionType.clear, precipitationProbability: 10, sunrise: '06:14 AM', sunset: '06:43 PM'),
    DailyForecast(date: '2026-08-25', dayName: 'Fri', tempMax: 30, tempMin: 24, condition: WeatherConditionType.partlyCloudy, precipitationProbability: 25, sunrise: '06:14 AM', sunset: '06:42 PM'),
  ];

  static const List<WeatherAlert> _mockAlerts = [
    WeatherAlert(
      id: 'alert-1',
      title: 'Heavy Rainfall Warning',
      description: 'Heavy monsoon showers expected between 02:00 PM and 05:00 PM. High precipitation may affect outdoor activities.',
      severity: 'warning',
      source: 'India Meteorological Department (IMD)',
    ),
  ];

  @override
  Future<WeatherSnapshot> getCurrentWeather(double lat, double lng, {String? location}) async {
    try {
      final response = await _dio.get('/weather/current', queryParameters: {'lat': lat, 'lng': lng, if (location != null) 'location': location});
      return WeatherSnapshot.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return _mockSnapshot;
    }
  }

  @override
  Future<List<HourlyForecast>> getHourlyForecast(double lat, double lng) async {
    try {
      final response = await _dio.get('/weather/forecast', queryParameters: {'lat': lat, 'lng': lng});
      final hourlyList = response.data['hourly'] as List<dynamic>;
      return hourlyList.map((e) => HourlyForecast.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockHourly;
    }
  }

  @override
  Future<List<DailyForecast>> getDailyForecast(double lat, double lng) async {
    try {
      final response = await _dio.get('/weather/forecast', queryParameters: {'lat': lat, 'lng': lng});
      final dailyList = response.data['daily'] as List<dynamic>;
      return dailyList.map((e) => DailyForecast.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockDaily;
    }
  }

  @override
  Future<List<WeatherAlert>> getWeatherAlerts(double lat, double lng) async {
    try {
      final response = await _dio.get('/weather/forecast', queryParameters: {'lat': lat, 'lng': lng});
      final alertsList = response.data['alerts'] as List<dynamic>;
      return alertsList.map((e) => WeatherAlert.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return _mockAlerts;
    }
  }
}

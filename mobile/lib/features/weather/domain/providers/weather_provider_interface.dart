import '../entities/weather_snapshot.dart';

abstract class WeatherProviderInterface {
  Future<WeatherSnapshot> getCurrentWeather(double lat, double lng, {String? location});
  Future<List<HourlyForecast>> getHourlyForecast(double lat, double lng);
  Future<List<DailyForecast>> getDailyForecast(double lat, double lng);
  Future<List<WeatherAlert>> getWeatherAlerts(double lat, double lng);
}

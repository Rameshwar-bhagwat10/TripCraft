import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';

enum WeatherConditionType {
  clear,
  partlyCloudy,
  cloudy,
  rain,
  heavyRain,
  thunderstorm,
  snow,
  fog,
  wind,
  unknown,
}

class WeatherConditionConfig {
  final WeatherConditionType type;
  final String label;
  final IconData icon;
  final Color accentColor;

  const WeatherConditionConfig({
    required this.type,
    required this.label,
    required this.icon,
    required this.accentColor,
  });

  static const Map<WeatherConditionType, WeatherConditionConfig> _configs = {
    WeatherConditionType.clear: WeatherConditionConfig(type: WeatherConditionType.clear, label: 'Sunny & Clear', icon: PhosphorIconsFill.sun, accentColor: Colors.amber),
    WeatherConditionType.partlyCloudy: WeatherConditionConfig(type: WeatherConditionType.partlyCloudy, label: 'Partly Cloudy', icon: PhosphorIconsFill.cloudSun, accentColor: Colors.orange),
    WeatherConditionType.cloudy: WeatherConditionConfig(type: WeatherConditionType.cloudy, label: 'Cloudy', icon: PhosphorIconsFill.cloud, accentColor: Colors.blueGrey),
    WeatherConditionType.rain: WeatherConditionConfig(type: WeatherConditionType.rain, label: 'Light Rain', icon: PhosphorIconsFill.cloudRain, accentColor: Colors.blue),
    WeatherConditionType.heavyRain: WeatherConditionConfig(type: WeatherConditionType.heavyRain, label: 'Heavy Rain', icon: PhosphorIconsFill.cloudRain, accentColor: Colors.indigo),
    WeatherConditionType.thunderstorm: WeatherConditionConfig(type: WeatherConditionType.thunderstorm, label: 'Thunderstorm', icon: PhosphorIconsFill.cloudLightning, accentColor: Colors.deepPurple),
    WeatherConditionType.snow: WeatherConditionConfig(type: WeatherConditionType.snow, label: 'Snow', icon: PhosphorIconsFill.snowflake, accentColor: Colors.cyan),
    WeatherConditionType.fog: WeatherConditionConfig(type: WeatherConditionType.fog, label: 'Foggy', icon: PhosphorIconsFill.cloudFog, accentColor: Colors.grey),
    WeatherConditionType.wind: WeatherConditionConfig(type: WeatherConditionType.wind, label: 'Windy', icon: PhosphorIconsFill.wind, accentColor: Colors.teal),
    WeatherConditionType.unknown: WeatherConditionConfig(type: WeatherConditionType.unknown, label: 'Moderate', icon: PhosphorIconsFill.cloudSun, accentColor: AppColors.primary),
  };

  static WeatherConditionConfig getConfig(WeatherConditionType type) {
    return _configs[type] ?? _configs[WeatherConditionType.clear]!;
  }

  static WeatherConditionType fromCode(String code) {
    switch (code.toLowerCase()) {
      case 'clear':
      case 'sunny':
        return WeatherConditionType.clear;
      case 'partly_cloudy':
      case 'partlycloudy':
        return WeatherConditionType.partlyCloudy;
      case 'cloudy':
      case 'overcast':
        return WeatherConditionType.cloudy;
      case 'rain':
      case 'shower':
        return WeatherConditionType.rain;
      case 'heavy_rain':
      case 'monsoon':
        return WeatherConditionType.heavyRain;
      case 'thunderstorm':
        return WeatherConditionType.thunderstorm;
      case 'snow':
        return WeatherConditionType.snow;
      case 'fog':
        return WeatherConditionType.fog;
      case 'wind':
        return WeatherConditionType.wind;
      default:
        return WeatherConditionType.partlyCloudy;
    }
  }
}

class WeatherSnapshot {
  final String location;
  final double latitude;
  final double longitude;
  final double temperature;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final WeatherConditionType condition;
  final String conditionDescription;
  final int humidity;
  final double windSpeed;
  final int precipitationProbability;
  final int? uvIndex;
  final String? sunrise;
  final String? sunset;
  final String observedAt;

  const WeatherSnapshot({
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.temperature,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.condition,
    required this.conditionDescription,
    required this.humidity,
    required this.windSpeed,
    required this.precipitationProbability,
    this.uvIndex,
    this.sunrise,
    this.sunset,
    required this.observedAt,
  });

  factory WeatherSnapshot.fromJson(Map<String, dynamic> json) {
    final condObj = json['condition'] as Map<String, dynamic>? ?? {};
    final code = condObj['code'] as String? ?? 'partly_cloudy';

    return WeatherSnapshot(
      location: json['location'] as String? ?? 'Goa, India',
      latitude: (json['latitude'] as num? ?? 15.4989).toDouble(),
      longitude: (json['longitude'] as num? ?? 73.7725).toDouble(),
      temperature: (json['temperature'] as num? ?? 28.0).toDouble(),
      feelsLike: (json['feelsLike'] as num? ?? 31.0).toDouble(),
      tempMin: (json['tempMin'] as num? ?? 24.0).toDouble(),
      tempMax: (json['tempMax'] as num? ?? 30.0).toDouble(),
      condition: WeatherConditionConfig.fromCode(code),
      conditionDescription: condObj['description'] as String? ?? 'Partly cloudy',
      humidity: json['humidity'] as int? ?? 74,
      windSpeed: (json['windSpeed'] as num? ?? 14.0).toDouble(),
      precipitationProbability: json['precipitationProbability'] as int? ?? 35,
      uvIndex: json['uvIndex'] as int?,
      sunrise: json['sunrise'] as String?,
      sunset: json['sunset'] as String?,
      observedAt: json['observedAt'] as String? ?? DateTime.now().toIso8601String(),
    );
  }
}

class HourlyForecast {
  final String time;
  final double temperature;
  final double feelsLike;
  final WeatherConditionType condition;
  final int precipitationProbability;
  final double precipitationAmountMm;

  const HourlyForecast({
    required this.time,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.precipitationProbability,
    required this.precipitationAmountMm,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    final condObj = json['condition'] as Map<String, dynamic>? ?? {};
    final code = condObj['code'] as String? ?? 'clear';

    return HourlyForecast(
      time: json['time'] as String? ?? '12:00 PM',
      temperature: (json['temperature'] as num? ?? 28.0).toDouble(),
      feelsLike: (json['feelsLike'] as num? ?? 30.0).toDouble(),
      condition: WeatherConditionConfig.fromCode(code),
      precipitationProbability: json['precipitationProbability'] as int? ?? 20,
      precipitationAmountMm: (json['precipitationAmountMm'] as num? ?? 0.0).toDouble(),
    );
  }
}

class DailyForecast {
  final String date;
  final String dayName;
  final double tempMax;
  final double tempMin;
  final WeatherConditionType condition;
  final int precipitationProbability;
  final String sunrise;
  final String sunset;

  const DailyForecast({
    required this.date,
    required this.dayName,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
    required this.precipitationProbability,
    required this.sunrise,
    required this.sunset,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final condObj = json['condition'] as Map<String, dynamic>? ?? {};
    final code = condObj['code'] as String? ?? 'partly_cloudy';

    return DailyForecast(
      date: json['date'] as String? ?? '2026-08-21',
      dayName: json['dayName'] as String? ?? 'Mon',
      tempMax: (json['tempMax'] as num? ?? 30.0).toDouble(),
      tempMin: (json['tempMin'] as num? ?? 24.0).toDouble(),
      condition: WeatherConditionConfig.fromCode(code),
      precipitationProbability: json['precipitationProbability'] as int? ?? 30,
      sunrise: json['sunrise'] as String? ?? '06:12 AM',
      sunset: json['sunset'] as String? ?? '06:45 PM',
    );
  }
}

class WeatherAlert {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String source;

  const WeatherAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.source,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Weather Alert',
      description: json['description'] as String? ?? '',
      severity: json['severity'] as String? ?? 'warning',
      source: json['source'] as String? ?? 'Met Office',
    );
  }
}

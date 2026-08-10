import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/weather_snapshot.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherSnapshot weather;

  const CurrentWeatherCard({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final config = WeatherConditionConfig.getConfig(weather.condition);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            config.accentColor.withValues(alpha: 0.15),
            AppColors.surface,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.accentColor.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.03),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(PhosphorIconsRegular.mapPin, size: 16, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(
                    weather.location.toUpperCase(),
                    style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: config.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(config.icon, size: 14, color: config.accentColor),
                    const SizedBox(width: 6),
                    Text(
                      config.label,
                      style: AppTypography.labelSmall.copyWith(
                        color: config.accentColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          // Temperature Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${weather.temperature.round()}°',
                style: AppTypography.displayLarge.copyWith(
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: AppDimensions.space12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feels like ${weather.feelsLike.round()}°',
                    style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    weather.conditionDescription,
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space20),

          // Metadata Grid
          Container(
            padding: const EdgeInsets.all(AppDimensions.space12),
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetric(PhosphorIconsRegular.drop, '${weather.humidity}%', 'Humidity'),
                Container(width: 1, height: 28, color: AppColors.border),
                _buildMetric(PhosphorIconsRegular.wind, '${weather.windSpeed.round()} km/h', 'Wind'),
                Container(width: 1, height: 28, color: AppColors.border),
                _buildMetric(PhosphorIconsRegular.cloudRain, '${weather.precipitationProbability}%', 'Rain Prob'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(value, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
        const SizedBox(height: 2),
        Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 10)),
      ],
    );
  }
}

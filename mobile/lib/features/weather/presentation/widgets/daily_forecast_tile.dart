import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/weather_snapshot.dart';

class DailyForecastTile extends StatelessWidget {
  final DailyForecast forecast;

  const DailyForecastTile({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    final config = WeatherConditionConfig.getConfig(forecast.condition);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.space8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              forecast.dayName,
              style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          Icon(config.icon, size: 20, color: config.accentColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              config.label,
              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ),
          if (forecast.precipitationProbability > 20)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${forecast.precipitationProbability}% rain',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          Text(
            '${forecast.tempMax.round()}° / ${forecast.tempMin.round()}°',
            style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}

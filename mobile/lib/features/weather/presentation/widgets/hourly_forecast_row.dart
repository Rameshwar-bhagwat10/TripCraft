import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/weather_snapshot.dart';

class HourlyForecastRow extends StatelessWidget {
  final List<HourlyForecast> forecast;

  const HourlyForecastRow({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 104,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: forecast.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.space8),
        itemBuilder: (context, index) {
          final item = forecast[index];
          final config = WeatherConditionConfig.getConfig(item.condition);
          final isRainRisk = item.precipitationProbability >= 50;

          return Container(
            width: 76,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
              color: isRainRisk ? AppColors.primarySurface : AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isRainRisk ? AppColors.primary.withValues(alpha: 0.4) : AppColors.border,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.time,
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(config.icon, size: 20, color: config.accentColor),
                Text(
                  '${item.temperature.round()}°',
                  style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w800),
                ),
                if (item.precipitationProbability > 0)
                  Text(
                    '${item.precipitationProbability}%',
                    style: AppTypography.labelSmall.copyWith(
                      color: isRainRisk ? AppColors.primary : AppColors.textTertiary,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

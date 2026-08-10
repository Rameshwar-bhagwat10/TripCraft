import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';

import '../providers/weather_provider.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_tile.dart';
import '../widgets/hourly_forecast_row.dart';

class TripWeatherScreen extends ConsumerWidget {
  final String tripId;

  const TripWeatherScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const locationKey = '15.4989,73.7725';
    final state = ref.watch(weatherProvider(locationKey));

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Trip Weather Forecast', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.current != null) ...[
                      CurrentWeatherCard(weather: state.current!),
                      const SizedBox(height: AppDimensions.space20),
                    ],

                    // Weather Alerts Section
                    if (state.alerts.isNotEmpty) ...[
                      Text('WEATHER ALERTS', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                      const SizedBox(height: AppDimensions.space8),
                      ...state.alerts.map((alert) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: AppDimensions.space12),
                          padding: const EdgeInsets.all(AppDimensions.space14),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(PhosphorIconsFill.warning, color: AppColors.error, size: 20),
                              const SizedBox(width: AppDimensions.space10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(alert.title, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.error)),
                                    const SizedBox(height: 4),
                                    Text(alert.description, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4)),
                                    const SizedBox(height: 6),
                                    Text('Source: ${alert.source}', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, fontSize: 10)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: AppDimensions.space16),
                    ],

                    // Hourly Forecast Section
                    Text('HOURLY FORECAST', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space8),
                    HourlyForecastRow(forecast: state.hourly),
                    const SizedBox(height: AppDimensions.space24),

                    // 5-Day Daily Forecast Section
                    Text('5-DAY DESTINATION FORECAST', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space8),
                    ...state.daily.map((day) => DailyForecastTile(forecast: day)),
                    const SizedBox(height: AppDimensions.space24),
                  ],
                ),
              ),
      ),
    );
  }
}

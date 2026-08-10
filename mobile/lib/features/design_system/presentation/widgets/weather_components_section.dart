import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../smart_trip_intelligence/domain/entities/trip_readiness.dart';
import '../../../smart_trip_intelligence/presentation/widgets/trip_readiness_card.dart';

class WeatherComponentsSection extends StatelessWidget {
  const WeatherComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const sampleReadiness = TripReadiness(
      status: ReadinessStatus.needsReview,
      summary: '2 weather-sensitive outdoor activities overlap with expected afternoon monsoon rain on Day 2.',
      weatherFactorLabel: 'Afternoon rain expected',
      isWeatherWarning: true,
      routeFactorLabel: 'Efficient travel route',
      isRouteWarning: false,
      scheduleFactorLabel: '1 timing conflict',
      isScheduleWarning: true,
      activityFactorLabel: '5 well-distributed activities',
      isActivityWarning: false,
    );

    return SectionLayout(
      title: 'Weather & Smart Trip Intelligence',
      subtitle: 'Trip Readiness Badge & Health Breakdown',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TripReadinessCard(
            readiness: sampleReadiness,
          ),
          SizedBox(height: AppDimensions.space12),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../route_intelligence/domain/entities/route_insight.dart';
import '../../../route_intelligence/presentation/widgets/route_insight_card.dart';

class MapComponentsSection extends StatelessWidget {
  const MapComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    const sampleInsight = RouteInsight(
      id: 'ins-showcase-1',
      type: 'backtracking',
      severity: InsightSeverity.warning,
      title: 'Backtracking Detected',
      description: 'You travel from Central Panaji to North Candolim, then Baga, and return east to Old Goa.',
      estimatedTimeSavedMins: 24,
      estimatedDistanceSavedKm: 6.8,
      recommendedAction: 'Reorder stops to visit coastal sites consecutively.',
    );

    return SectionLayout(
      title: 'Maps & Route Intelligence',
      subtitle: 'Route Insight Cards & Optimization Alerts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          RouteInsightCard(
            insight: sampleInsight,
          ),
          SizedBox(height: AppDimensions.space12),
        ],
      ),
    );
  }
}

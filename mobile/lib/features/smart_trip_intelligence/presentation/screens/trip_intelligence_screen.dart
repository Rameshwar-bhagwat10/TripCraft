import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';

import '../../../route_intelligence/presentation/widgets/route_insight_card.dart';
import '../../../weather/presentation/widgets/weather_details_sheet.dart';
import '../providers/smart_trip_intelligence_provider.dart';
import '../widgets/trip_readiness_card.dart';

class TripIntelligenceScreen extends ConsumerWidget {
  final String tripId;

  const TripIntelligenceScreen({
    super.key,
    required this.tripId,
  });

  void _handleInsightAction(BuildContext context, dynamic insight) {
    if (insight.type == 'weatherConflict') {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return WeatherDetailsSheet(
            activityTitle: insight.affectedActivityTitle ?? 'Baga Beach Watersports',
            time: '03:00 PM',
            weatherSummary: 'Heavy monsoon rain expected',
            rainProbability: 85,
            alternatives: const [],
            onSubstitute: () {
              AppSnackBar.show(context, message: 'Substituted outdoor activity with Museum of Christian Art!');
            },
          );
        },
      );
    } else {
      AppSnackBar.show(context, message: 'Insight action reviewed.');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(smartTripIntelligenceProvider(tripId));

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Smart Trip Intelligence', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.arrowsClockwise, color: AppColors.primary),
            onPressed: () => ref.read(smartTripIntelligenceProvider(tripId).notifier).refresh(),
            tooltip: 'Refresh Intelligence',
          ),
        ],
      ),
      body: SafeArea(
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (state.data?.readiness != null) ...[
                      TripReadinessCard(readiness: state.data!.readiness),
                      const SizedBox(height: AppDimensions.space20),
                    ],

                    PrimaryButton(
                      label: 'Optimize Trip Schedule',
                      icon: const Icon(PhosphorIconsFill.sparkle, size: 18, color: Colors.amber),
                      onPressed: () {
                        AppSnackBar.show(context, message: 'Schedule optimization preview applied!');
                      },
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    Text('PRIORITIZED TRIP INSIGHTS', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space12),

                    if (state.data?.insights != null) ...[
                      ...state.data!.insights.map((insight) {
                        return RouteInsightCard(
                          insight: insight,
                          onAction: () => _handleInsightAction(context, insight),
                        );
                      }),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

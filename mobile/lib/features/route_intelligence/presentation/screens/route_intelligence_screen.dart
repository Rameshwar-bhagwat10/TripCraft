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

import '../providers/route_intelligence_provider.dart';
import '../widgets/route_insight_card.dart';
import '../widgets/route_optimization_sheet.dart';

class RouteIntelligenceScreen extends ConsumerWidget {
  final String tripId;
  final String dayId;

  const RouteIntelligenceScreen({
    super.key,
    required this.tripId,
    required this.dayId,
  });

  void _showOptimizationPreview(BuildContext context, dynamic optimizationResult) {
    if (optimizationResult == null) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return RouteOptimizationSheet(
          result: optimizationResult,
          onApply: () {
            context.pop();
            AppSnackBar.show(context, message: 'Applied optimized route order! Saved ${optimizationResult.timeSavingsMins} mins.');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = '$tripId:$dayId';
    final state = ref.watch(routeIntelligenceProvider(key));

    final efficiencyScore = state.analysis?.efficiencyScore ?? 78;
    final insights = state.analysis?.insights ?? [];

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Route Intelligence', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
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
                    // Efficiency Summary Header Card
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ROUTE EFFICIENCY',
                                style: AppTypography.labelSmall.copyWith(color: Colors.white70, letterSpacing: 1.0),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$efficiencyScore / 100',
                                  style: AppTypography.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.space12),
                          Text(
                            state.analysis?.travelBurdenLevel == 'Moderate'
                                ? 'Moderate Travel Burden'
                                : 'Optimal Travel Route',
                            style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${state.analysis?.totalDistanceKm ?? 42.6} km total distance · ${state.analysis?.totalDurationMins ?? 95} mins travel time',
                            style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Primary Optimize Action Button
                    PrimaryButton(
                      label: 'Optimize Route & Order',
                      icon: const Icon(PhosphorIconsFill.sparkle, size: 18, color: Colors.amber),
                      onPressed: () => _showOptimizationPreview(context, state.optimization),
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Findings & Insights List
                    Text('SMART INSIGHTS & WARNINGS', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space12),

                    if (insights.isEmpty) ...[
                      Text('No warnings found. Your route is looking great!', style: AppTypography.bodyMedium),
                    ] else ...[
                      ...insights.map((insight) {
                        return RouteInsightCard(
                          insight: insight,
                          onAction: () => _showOptimizationPreview(context, state.optimization),
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

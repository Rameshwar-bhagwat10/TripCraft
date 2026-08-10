import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../providers/trip_finance_provider.dart';

class FinanceAnalyticsScreen extends ConsumerWidget {
  final String tripId;

  const FinanceAnalyticsScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripFinanceProvider(tripId));
    final analytics = state.analytics;

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Financial Analytics', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: analytics == null
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overview Metric Strip
                    Row(
                      children: [
                        Expanded(
                          child: _buildMetricTile(
                            'Daily Avg Spend',
                            '₹${analytics.dailyAverageSpend.toStringAsFixed(0)}',
                            PhosphorIconsRegular.chartLineUp,
                            AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildMetricTile(
                            'Projected Final',
                            '₹${analytics.projectedTotalSpend.toStringAsFixed(0)}',
                            PhosphorIconsRegular.trendUp,
                            Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Spending Insights Card
                    Text('FINANCIAL INSIGHTS', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space10),

                    Container(
                      padding: const EdgeInsets.all(AppDimensions.space16),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: analytics.spendingInsights.map((insight) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                const Icon(PhosphorIconsFill.sparkle, color: AppColors.primary, size: 16),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    insight,
                                    style: AppTypography.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space24),

                    // Category Breakdown List
                    Text('CATEGORY SPENDING BREAKDOWN', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
                    const SizedBox(height: AppDimensions.space10),

                    ...analytics.categoryBreakdown.map((item) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                        child: Container(
                          padding: const EdgeInsets.all(AppDimensions.space14),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.categoryName, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('₹${item.amount.toStringAsFixed(0)}', style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w800)),
                                  Text('${item.percentage}% of total', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 10)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

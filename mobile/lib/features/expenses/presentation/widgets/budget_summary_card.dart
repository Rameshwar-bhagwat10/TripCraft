import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/trip_budget.dart';

class BudgetSummaryCard extends StatelessWidget {
  final TripBudget budget;

  const BudgetSummaryCard({
    super.key,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = BudgetStatusConfig.getConfig(budget.status);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TRIP FINANCIAL BUDGET',
                style: AppTypography.labelSmall.copyWith(color: Colors.white70, letterSpacing: 1.0),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusConfig.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusConfig.color.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(statusConfig.icon, size: 14, color: statusConfig.color),
                    const SizedBox(width: 6),
                    Text(
                      statusConfig.label.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(color: statusConfig.color, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '${budget.currency} ${budget.spentAmount.toStringAsFixed(0)}',
                style: AppTypography.displayMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              Text(
                'spent of ${budget.currency} ${budget.totalBudget.toStringAsFixed(0)}',
                style: AppTypography.bodyMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          // Progress Meter Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: (budget.percentageUsed / 100).clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              valueColor: AlwaysStoppedAnimation<Color>(statusConfig.color),
            ),
          ),
          const SizedBox(height: AppDimensions.space12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${budget.percentageUsed.toStringAsFixed(1)}% Used',
                style: AppTypography.bodySmall.copyWith(color: Colors.white70, fontSize: 11),
              ),
              Text(
                '${budget.currency} ${budget.remainingAmount.toStringAsFixed(0)} Remaining',
                style: AppTypography.bodySmall.copyWith(color: Colors.amber, fontWeight: FontWeight.w700, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

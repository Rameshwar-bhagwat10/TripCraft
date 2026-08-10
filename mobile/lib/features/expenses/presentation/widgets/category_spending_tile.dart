import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/trip_budget.dart';
import '../../domain/entities/expense.dart';

class CategorySpendingTile extends StatelessWidget {
  final CategoryBudget categoryBudget;

  const CategorySpendingTile({
    super.key,
    required this.categoryBudget,
  });

  @override
  Widget build(BuildContext context) {
    final catEnum = ExpenseCategoryConfig.fromString(categoryBudget.categoryId);
    final catConfig = ExpenseCategoryConfig.getConfig(catEnum);
    final pct = (categoryBudget.percentageUsed / 100).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(catConfig.icon, size: 16, color: catConfig.color),
                  const SizedBox(width: 8),
                  Text(categoryBudget.categoryName, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                ],
              ),
              Text(
                '₹${categoryBudget.spentAmount.toStringAsFixed(0)} / ₹${categoryBudget.allocatedAmount.toStringAsFixed(0)}',
                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              minHeight: 6,
              backgroundColor: AppColors.surfaceSecondary,
              valueColor: AlwaysStoppedAnimation<Color>(catConfig.color),
            ),
          ),
        ],
      ),
    );
  }
}

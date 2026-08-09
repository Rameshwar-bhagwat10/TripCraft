import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

/// Reusable iOS-style Traveler Count Stepper.
class TravelerStepper extends StatelessWidget {
  final int count;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const TravelerStepper({
    super.key,
    required this.count,
    required this.onChanged,
    this.min = 1,
    this.max = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space16,
        vertical: AppDimensions.space12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                PhosphorIconsRegular.users,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppDimensions.space12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Travelers',
                    style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    count == 1 ? 'Solo traveler' : '$count travelers',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(PhosphorIconsBold.minus, size: 16),
                color: count > min ? AppColors.primary : AppColors.textTertiary,
                onPressed: count > min
                    ? () {
                        HapticFeedback.selectionClick();
                        onChanged(count - 1);
                      }
                    : null,
              ),
              Text(
                '$count',
                style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700),
              ),
              IconButton(
                icon: const Icon(PhosphorIconsBold.plus, size: 16),
                color: count < max ? AppColors.primary : AppColors.textTertiary,
                onPressed: count < max
                    ? () {
                        HapticFeedback.selectionClick();
                        onChanged(count + 1);
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

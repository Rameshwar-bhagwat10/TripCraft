import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

/// Reusable AI Visual Badge Primitive in TripCraft.
class AIBadge extends StatelessWidget {
  final String label;

  const AIBadge({
    super.key,
    this.label = 'AI Copilot',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: AppColors.aiAccentLight,
        borderRadius: AppDimensions.borderXS,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            PhosphorIconsRegular.sparkle,
            size: 14,
            color: AppColors.aiAccent,
          ),
          const SizedBox(width: AppDimensions.space4),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.aiAccent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

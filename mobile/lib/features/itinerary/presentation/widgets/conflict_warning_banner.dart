import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/itinerary.dart';

/// Warning banner displayed when schedule overlap is detected.
class ConflictWarningBanner extends StatelessWidget {
  final List<ItineraryConflict> conflicts;

  const ConflictWarningBanner({
    super.key,
    required this.conflicts,
  });

  @override
  Widget build(BuildContext context) {
    if (conflicts.isEmpty) return const SizedBox.shrink();

    final conflict = conflicts.first;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.space16),
      padding: const EdgeInsets.all(AppDimensions.space12),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2), // Red tint surface
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(PhosphorIconsBold.warningCircle, color: AppColors.error, size: 20),
          const SizedBox(width: AppDimensions.space10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Schedule Conflict Detected',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '"${conflict.item1.title}" (${conflict.item1.startTime}) overlaps with "${conflict.item2.title}" (${conflict.item2.startTime})',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

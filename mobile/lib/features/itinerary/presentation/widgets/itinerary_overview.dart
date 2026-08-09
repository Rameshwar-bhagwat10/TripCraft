import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/itinerary.dart';

/// Overview mode displaying summary of all trip days.
class ItineraryOverview extends StatelessWidget {
  final List<TripDay> days;
  final ValueChanged<int> onDayTap;

  const ItineraryOverview({
    super.key,
    required this.days,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    final plannedCount = days.where((d) => d.items.isNotEmpty).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.pageMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Summary Strip
          Container(
            padding: const EdgeInsets.all(AppDimensions.space16),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(PhosphorIconsFill.sparkle, color: AppColors.primary, size: 24),
                const SizedBox(width: AppDimensions.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$plannedCount of ${days.length} Days Scheduled',
                        style: AppTypography.titleSmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Tap any day below to view and edit its detailed timeline.',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space20),

          // Day Summary Cards List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.space12),
            itemBuilder: (context, index) {
              final day = days[index];

              String dateStr = 'Day ${day.dayNumber}';
              try {
                final dt = DateTime.parse(day.date);
                final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                dateStr = '${weekdays[dt.weekday - 1]}, ${monthNames[dt.month - 1]} ${dt.day}';
              } catch (_) {}

              return GestureDetector(
                onTap: () => onDayTap(index),
                child: Container(
                  padding: const EdgeInsets.all(AppDimensions.space16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: day.items.isNotEmpty ? AppColors.primarySurface : AppColors.surfaceSecondary,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${day.dayNumber}',
                          style: AppTypography.titleSmall.copyWith(
                            color: day.items.isNotEmpty ? AppColors.primary : AppColors.textTertiary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.space12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Day ${day.dayNumber}${day.title != null && day.title!.isNotEmpty ? " · ${day.title}" : ""}',
                              style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '$dateStr · ${day.items.length} ${day.items.length == 1 ? "activity" : "activities"}',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                      const Icon(PhosphorIconsRegular.caretRight, size: 16, color: AppColors.textTertiary),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

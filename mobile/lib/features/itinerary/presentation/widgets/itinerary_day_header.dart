import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/itinerary.dart';

/// Reusable Day Header with title & editing affordance.
class ItineraryDayHeader extends StatelessWidget {
  final TripDay day;
  final VoidCallback? onEditTitle;

  const ItineraryDayHeader({
    super.key,
    required this.day,
    this.onEditTitle,
  });

  @override
  Widget build(BuildContext context) {
    String fullDateStr = 'Day ${day.dayNumber}';
    try {
      final dt = DateTime.parse(day.date);
      final weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
      fullDateStr = '${weekdays[dt.weekday - 1]}, ${monthNames[dt.month - 1]} ${dt.day}';
    } catch (_) {}

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Day ${day.dayNumber}${day.title != null && day.title!.isNotEmpty ? " · ${day.title}" : ""}',
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                fullDateStr,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(PhosphorIconsRegular.pencilSimple, size: 18, color: AppColors.textTertiary),
          onPressed: onEditTitle,
        ),
      ],
    );
  }
}

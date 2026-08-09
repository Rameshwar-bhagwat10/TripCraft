import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/itinerary.dart';

/// Reusable iOS-style Horizontal Day Selector for Itinerary.
class ItineraryDaySelector extends StatelessWidget {
  final List<TripDay> days;
  final int selectedIndex;
  final ValueChanged<int> onDaySelected;

  const ItineraryDaySelector({
    super.key,
    required this.days,
    required this.selectedIndex,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    if (days.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
        itemCount: days.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.space8),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = index == selectedIndex;

          String dateLabel = 'Day ${day.dayNumber}';
          try {
            final dt = DateTime.parse(day.date);
            final monthNames = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
            dateLabel = '${monthNames[dt.month - 1]} ${dt.day}';
          } catch (_) {}

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onDaySelected(index);
            },
            child: Container(
              width: 80,
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 1.5,
                ),
                boxShadow: isSelected
                    ? const [
                        BoxShadow(
                          color: Color.fromRGBO(15, 118, 110, 0.25),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'DAY ${day.dayNumber}',
                      style: AppTypography.labelSmall.copyWith(
                        color: isSelected ? Colors.white70 : AppColors.textTertiary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dateLabel,
                      style: AppTypography.titleSmall.copyWith(
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

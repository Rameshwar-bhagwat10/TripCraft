import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/entities/place.dart';

class AddPlaceToTripSheet extends StatefulWidget {
  final Place place;
  final Function(int dayNumber, String startTime) onAdd;

  const AddPlaceToTripSheet({
    super.key,
    required this.place,
    required this.onAdd,
  });

  @override
  State<AddPlaceToTripSheet> createState() => _AddPlaceToTripSheetState();
}

class _AddPlaceToTripSheetState extends State<AddPlaceToTripSheet> {
  int _selectedDayNumber = 1;
  TimeOfDay _startTime = const TimeOfDay(hour: 10, minute: 30);
  bool _isSubmitting = false;

  Future<void> _pickTime() async {
    final picked = await showTimePicker(context: context, initialTime: _startTime);
    if (picked != null) {
      setState(() => _startTime = picked);
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final h = tod.hour.toString().padLeft(2, '0');
    final m = tod.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppDimensions.space16,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.space24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          Text('Add to Itinerary', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(widget.place.name, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: AppDimensions.space20),

          // Day Selection
          Text('SELECT TRIP DAY', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
          const SizedBox(height: AppDimensions.space8),
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final dayNum = index + 1;
                final isSelected = _selectedDayNumber == dayNum;

                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    setState(() => _selectedDayNumber = dayNum);
                  },
                  child: Container(
                    width: 72,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                    ),
                    child: Center(
                      child: Text(
                        'Day $dayNum',
                        style: AppTypography.labelMedium.copyWith(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimensions.space20),

          // Start Time Picker
          Text('START TIME', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
          const SizedBox(height: AppDimensions.space8),
          GestureDetector(
            onTap: _pickTime,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.space14),
              decoration: BoxDecoration(
                color: AppColors.surfaceSecondary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_startTime.format(context), style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                  const Icon(Icons.access_time, size: 18, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space24),

          PrimaryButton(
            label: 'Add to Day $_selectedDayNumber',
            isLoading: _isSubmitting,
            onPressed: () {
              setState(() => _isSubmitting = true);
              widget.onAdd(_selectedDayNumber, _formatTimeOfDay(_startTime));
            },
          ),
        ],
      ),
    );
  }
}

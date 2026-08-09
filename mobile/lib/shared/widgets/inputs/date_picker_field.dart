import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';
import '../../../core/utils/date_utils.dart';

/// Reusable Date Picker input representation for TripCraft.
class DatePickerField extends StatelessWidget {
  final String? label;
  final DateTime? selectedDate;
  final String placeholder;
  final ValueChanged<DateTime>? onDateSelected;
  final String? errorText;
  final bool enabled;

  const DatePickerField({
    super.key,
    this.label,
    this.selectedDate,
    this.placeholder = 'Select date',
    this.onDateSelected,
    this.errorText,
    this.enabled = true,
  });

  Future<void> _selectDate(BuildContext context) async {
    if (!enabled) return;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null && onDateSelected != null) {
      onDateSelected!(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValue = selectedDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
        ],
        InkWell(
          onTap: enabled ? () => _selectDate(context) : null,
          borderRadius: AppDimensions.inputRadius,
          child: Container(
            height: AppDimensions.inputHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.space16,
            ),
            decoration: BoxDecoration(
              color: enabled ? AppColors.surface : AppColors.surfaceSecondary,
              borderRadius: AppDimensions.inputRadius,
              border: Border.all(
                color: errorText != null ? AppColors.error : AppColors.border,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? AppDateUtils.formatDate(selectedDate!) : placeholder,
                    style: AppTypography.bodyMedium.copyWith(
                      color: hasValue
                          ? AppColors.textPrimary
                          : AppColors.textDisabled,
                    ),
                  ),
                ),
                Icon(
                  PhosphorIconsRegular.calendar,
                  size: AppDimensions.iconMD,
                  color: enabled ? AppColors.primary : AppColors.textDisabled,
                ),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppDimensions.space4),
          Text(
            errorText!,
            style: AppTypography.bodySmall.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
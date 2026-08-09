import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/entities/destination.dart';

/// Reusable Apple-inspired Filter Bottom Sheet.
class FilterBottomSheet extends StatefulWidget {
  final DestinationFilter currentFilter;
  final ValueChanged<DestinationFilter> onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  static Future<void> show(
    BuildContext context, {
    required DestinationFilter currentFilter,
    required ValueChanged<DestinationFilter> onApply,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterBottomSheet(
        currentFilter: currentFilter,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String? _selectedBudget;
  late String? _selectedStyle;

  static const List<String> budgetOptions = ['Budget', 'Moderate', 'Premium', 'Luxury'];
  static const List<String> styleOptions = ['Relaxation', 'Adventure', 'Nature', 'Culture', 'Culinary', 'Wellness'];

  @override
  void initState() {
    super.initState();
    _selectedBudget = widget.currentFilter.budget;
    _selectedStyle = widget.currentFilter.travelStyle;
  }

  void _resetFilters() {
    setState(() {
      _selectedBudget = null;
      _selectedStyle = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(AppDimensions.pageMargin),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Destinations',
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
              ),
              TextButton(
                onPressed: _resetFilters,
                child: Text(
                  'Reset',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          // Budget Section
          Text(
            'BUDGET LEVEL',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          Wrap(
            spacing: AppDimensions.space8,
            children: budgetOptions.map((budget) {
              final isSelected = _selectedBudget?.toLowerCase() == budget.toLowerCase();
              return ChoiceChip(
                selected: isSelected,
                label: Text(budget),
                selectedColor: AppColors.primarySurface,
                backgroundColor: AppColors.surface,
                labelStyle: AppTypography.bodySmall.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                onSelected: (val) {
                  setState(() => _selectedBudget = val ? budget : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.space20),

          // Travel Style Section
          Text(
            'TRAVEL STYLE',
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textTertiary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppDimensions.space8),
          Wrap(
            spacing: AppDimensions.space8,
            runSpacing: AppDimensions.space8,
            children: styleOptions.map((style) {
              final isSelected = _selectedStyle?.toLowerCase() == style.toLowerCase();
              return ChoiceChip(
                selected: isSelected,
                label: Text(style),
                selectedColor: AppColors.primarySurface,
                backgroundColor: AppColors.surface,
                labelStyle: AppTypography.bodySmall.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                onSelected: (val) {
                  setState(() => _selectedStyle = val ? style : null);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.space28),

          PrimaryButton(
            label: 'Apply Filters',
            onPressed: () {
              widget.onApply(
                widget.currentFilter.copyWith(
                  budget: _selectedBudget,
                  travelStyle: _selectedStyle,
                ),
              );
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: AppDimensions.space12),
        ],
      ),
    );
  }
}

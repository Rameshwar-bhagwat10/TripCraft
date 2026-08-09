import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

/// Reusable Sort Action Sheet Component.
class SortBottomSheet extends StatelessWidget {
  final String? currentSort;
  final ValueChanged<String> onSelectSort;

  const SortBottomSheet({
    super.key,
    this.currentSort,
    required this.onSelectSort,
  });

  static Future<void> show(
    BuildContext context, {
    required String? currentSort,
    required ValueChanged<String> onSelectSort,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SortBottomSheet(
        currentSort: currentSort,
        onSelectSort: onSelectSort,
      ),
    );
  }

  static const List<String> sortOptions = ['Recommended', 'Popular', 'Trending', 'Alphabetical'];

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
          Text(
            'Sort Destinations',
            style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppDimensions.space12),
          ...sortOptions.map((opt) {
            final isSelected = currentSort == opt || (currentSort == null && opt == 'Recommended');
            return ListTile(
              title: Text(
                opt,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              trailing: isSelected
                  ? const Icon(PhosphorIconsBold.check, color: AppColors.primary, size: 20)
                  : null,
              onTap: () {
                onSelectSort(opt);
                Navigator.of(context).pop();
              },
            );
          }),
          const SizedBox(height: AppDimensions.space12),
        ],
      ),
    );
  }
}

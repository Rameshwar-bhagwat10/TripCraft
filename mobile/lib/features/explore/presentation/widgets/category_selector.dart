import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

class CategoryItem {
  final String label;
  final IconData icon;

  const CategoryItem({
    required this.label,
    required this.icon,
  });

  static const List<CategoryItem> categories = [
    CategoryItem(label: 'Beach', icon: PhosphorIconsRegular.sun),
    CategoryItem(label: 'Mountains', icon: PhosphorIconsRegular.mountains),
    CategoryItem(label: 'Adventure', icon: PhosphorIconsRegular.compass),
    CategoryItem(label: 'Culture', icon: PhosphorIconsRegular.buildings),
    CategoryItem(label: 'Nature', icon: PhosphorIconsRegular.tree),
    CategoryItem(label: 'Food', icon: PhosphorIconsRegular.forkKnife),
    CategoryItem(label: 'Luxury', icon: PhosphorIconsRegular.crown),
  ];
}

/// Horizontal Category Chips Selector Component.
class CategorySelector extends StatelessWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onCategorySelected;

  const CategorySelector({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: CategoryItem.categories.map((cat) {
          final isSelected = selectedCategory?.toLowerCase() == cat.label.toLowerCase();

          return Padding(
            padding: const EdgeInsets.only(right: AppDimensions.space8),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    cat.icon,
                    size: 14,
                    color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.label,
                    style: AppTypography.labelSmall.copyWith(
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primarySurface,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              showCheckmark: false,
              onSelected: (_) => onCategorySelected(cat.label),
            ),
          );
        }).toList(),
      ),
    );
  }
}

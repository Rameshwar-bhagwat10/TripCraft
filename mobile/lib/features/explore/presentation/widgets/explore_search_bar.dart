import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

/// Reusable Explore Search Bar with Filter Affordance Button.
class ExploreSearchBar extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onFilterTap;
  final int activeFilterCount;
  final String placeholder;

  const ExploreSearchBar({
    super.key,
    this.onTap,
    this.onFilterTap,
    this.activeFilterCount = 0,
    this.placeholder = 'Search destinations, cities, activities...',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space12,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              PhosphorIconsRegular.magnifyingGlass,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Text(
                placeholder,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (onFilterTap != null) ...[
              const SizedBox(width: AppDimensions.space8),
              GestureDetector(
                onTap: onFilterTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: activeFilterCount > 0
                        ? AppColors.primary
                        : AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        PhosphorIconsBold.slidersHorizontal,
                        color: activeFilterCount > 0
                            ? Colors.white
                            : AppColors.primary,
                        size: 16,
                      ),
                      if (activeFilterCount > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '$activeFilterCount',
                          style: AppTypography.labelSmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

enum AppChipVariant {
  standard,
  selected,
  outlined,
  success,
  warning,
  ai,
}

/// Reusable Chip Component for TripCraft categories and filters.
class AppChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? icon;
  final AppChipVariant variant;

  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.variant = AppChipVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    final effectiveVariant = isSelected ? AppChipVariant.selected : variant;

    switch (effectiveVariant) {
      case AppChipVariant.selected:
        bg = AppColors.primaryLight;
        fg = AppColors.primaryDark;
        border = const BorderSide(color: AppColors.primary, width: 1);
        break;
      case AppChipVariant.outlined:
        bg = Colors.transparent;
        fg = AppColors.textSecondary;
        border = const BorderSide(color: AppColors.borderStrong, width: 1);
        break;
      case AppChipVariant.success:
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;
      case AppChipVariant.warning:
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        break;
      case AppChipVariant.ai:
        bg = AppColors.aiAccentLight;
        fg = AppColors.aiAccent;
        break;
      case AppChipVariant.standard:
        bg = AppColors.surfaceSecondary;
        fg = AppColors.textPrimary;
        break;
    }

    return Material(
      color: bg,
      borderRadius: AppDimensions.borderPill,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimensions.borderPill,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.space12,
            vertical: AppDimensions.space6,
          ),
          decoration: BoxDecoration(
            borderRadius: AppDimensions.borderPill,
            border: border != BorderSide.none ? Border.fromBorderSide(border) : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: AppDimensions.space6),
              ],
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: fg,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

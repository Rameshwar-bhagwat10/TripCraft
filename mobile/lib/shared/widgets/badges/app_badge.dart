import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

enum AppBadgeVariant {
  standard,
  success,
  warning,
  error,
  info,
  premium,
}

/// Reusable Status & Category Badge Component in TripCraft.
class AppBadge extends StatelessWidget {
  final String label;
  final Widget? icon;
  final AppBadgeVariant variant;

  const AppBadge({
    super.key,
    required this.label,
    this.icon,
    this.variant = AppBadgeVariant.standard,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (variant) {
      case AppBadgeVariant.success:
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;
      case AppBadgeVariant.warning:
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        break;
      case AppBadgeVariant.error:
        bg = AppColors.errorLight;
        fg = AppColors.error;
        break;
      case AppBadgeVariant.info:
        bg = AppColors.infoLight;
        fg = AppColors.info;
        break;
      case AppBadgeVariant.premium:
        bg = AppColors.accentLight;
        fg = AppColors.accent;
        break;
      case AppBadgeVariant.standard:
        bg = AppColors.surfaceSecondary;
        fg = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space8,
        vertical: AppDimensions.space4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppDimensions.borderXS,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: AppDimensions.space4),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: fg,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

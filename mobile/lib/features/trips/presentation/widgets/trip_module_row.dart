import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

/// Reusable iOS-style Workspace Module Row for Trip Workspace.
class TripModuleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badgeText;
  final bool isAvailable;
  final VoidCallback? onTap;

  const TripModuleRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.isAvailable = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: isAvailable ? onTap : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space4,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isAvailable ? AppColors.primarySurface : AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: isAvailable ? AppColors.primary : AppColors.textTertiary,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Text(
              title,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
                color: isAvailable ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
            if (badgeText != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isAvailable ? AppColors.primarySurface : AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText!,
                  style: AppTypography.labelSmall.copyWith(
                    color: isAvailable ? AppColors.primary : AppColors.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          PhosphorIconsRegular.caretRight,
          size: 16,
          color: isAvailable ? AppColors.textTertiary : Colors.transparent,
        ),
      ),
    );
  }
}

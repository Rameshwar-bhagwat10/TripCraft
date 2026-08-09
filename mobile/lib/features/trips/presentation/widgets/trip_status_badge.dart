import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/trip.dart';

/// Reusable iOS-style Trip Status Badge.
class TripStatusBadge extends StatelessWidget {
  final TripStatus status;

  const TripStatusBadge({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (status) {
      case TripStatus.upcoming:
        bg = AppColors.primarySurface;
        text = AppColors.primary;
        break;
      case TripStatus.ongoing:
        bg = const Color(0xFFDCFCE7); // Light green
        text = AppColors.success;
        break;
      case TripStatus.completed:
        bg = AppColors.surfaceSecondary;
        text = AppColors.textSecondary;
        break;
      case TripStatus.draft:
        bg = const Color(0xFFFEF3C7); // Light amber
        text = AppColors.warning;
        break;
      case TripStatus.archived:
        bg = AppColors.surfaceSecondary;
        text = AppColors.textTertiary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label.toUpperCase(),
        style: AppTypography.labelSmall.copyWith(
          color: text,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

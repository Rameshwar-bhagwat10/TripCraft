import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

/// Reusable Loading Indicator Component for TripCraft.
class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final String? message;

  const LoadingIndicator({
    super.key,
    this.size = 28.0,
    this.color,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final Widget spinner = SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        valueColor: AlwaysStoppedAnimation<Color>(color ?? AppColors.primary),
      ),
    );

    if (message == null) return Center(child: spinner);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          spinner,
          const SizedBox(height: AppDimensions.space12),
          Text(
            message!,
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
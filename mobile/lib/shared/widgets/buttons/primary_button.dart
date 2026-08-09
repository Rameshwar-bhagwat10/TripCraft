import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

/// Reusable Primary Button for main call-to-actions in TripCraft.
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final bool isFullWidth;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.icon,
    this.isFullWidth = true,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPress = !isLoading && !isDisabled && onPressed != null;

    final Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: AppDimensions.space8),
        ],
        Text(
          label,
          style: AppTypography.buttonLabel.copyWith(
            color: canPress ? Colors.white : AppColors.textDisabled,
          ),
        ),
      ],
    );

    final Widget child = SizedBox(
      height: height ?? AppDimensions.buttonHeight,
      width: isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: canPress ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.surfaceTertiary,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: AppDimensions.buttonRadius,
          ),
        ),
        child: buttonContent,
      ),
    );

    return child;
  }
}
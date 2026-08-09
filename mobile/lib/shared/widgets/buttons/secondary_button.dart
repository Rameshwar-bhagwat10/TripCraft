import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

/// Reusable Secondary Button for secondary actions in TripCraft.
class SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Widget? icon;
  final bool isFullWidth;
  final double? height;

  const SecondaryButton({
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
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool canPress = !widget.isLoading && !widget.isDisabled && widget.onPressed != null;

    final Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.isLoading) ...[
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(width: AppDimensions.space8),
        ] else if (widget.icon != null) ...[
          widget.icon!,
          const SizedBox(width: AppDimensions.space8),
        ],
        Text(
          widget.label,
          style: AppTypography.labelLarge.copyWith(
            color: canPress ? AppColors.primary : AppColors.textDisabled,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );

    return AnimatedScale(
      scale: _isPressed && canPress ? 0.98 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        child: SizedBox(
          height: widget.height ?? AppDimensions.buttonHeight,
          width: widget.isFullWidth ? double.infinity : null,
          child: OutlinedButton(
            onPressed: canPress ? widget.onPressed : null,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surface,
              foregroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.surfaceSecondary,
              side: BorderSide(
                color: canPress ? AppColors.border : AppColors.border,
                width: 1.0,
              ),
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: AppDimensions.buttonRadius,
              ),
            ),
            child: buttonContent,
          ),
        ),
      ),
    );
  }
}
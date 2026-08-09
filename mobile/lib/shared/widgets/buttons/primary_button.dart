import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

/// Reusable Primary Button for main call-to-actions in TripCraft.
class PrimaryButton extends StatefulWidget {
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
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
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
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
            color: canPress ? Colors.white : AppColors.textDisabled,
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
          child: ElevatedButton(
            onPressed: canPress ? widget.onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.surfaceTertiary,
              elevation: 0,
              shadowColor: Colors.transparent,
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
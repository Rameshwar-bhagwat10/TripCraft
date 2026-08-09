import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';

/// Reusable Icon Button complying with minimum 48x48 touch targets in TripCraft.
class AppIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final Color? color;
  final Color? backgroundColor;
  final bool isDisabled;
  final double size;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
    this.backgroundColor,
    this.isDisabled = false,
    this.size = AppDimensions.minTouchTarget,
  });

  @override
  Widget build(BuildContext context) {
    final bool canPress = !isDisabled && onPressed != null;

    final Widget button = SizedBox(
      width: size,
      height: size,
      child: Material(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(size / 2),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          icon: icon,
          onPressed: canPress ? onPressed : null,
          color: color ?? AppColors.textSecondary,
          disabledColor: AppColors.textDisabled,
          tooltip: tooltip,
          padding: EdgeInsets.zero,
        ),
      ),
    );

    return tooltip != null ? Tooltip(message: tooltip, child: button) : button;
  }
}

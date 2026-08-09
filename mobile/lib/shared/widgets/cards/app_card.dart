import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_elevation.dart';

/// Reusable iOS-style Card Component in TripCraft.
class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isDisabled;
  final Color? backgroundColor;
  final Border? border;
  final List<BoxShadow>? shadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.isSelected = false,
    this.isDisabled = false,
    this.backgroundColor,
    this.border,
    this.shadow,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bool canTap = widget.onTap != null && !widget.isDisabled;

    final Color effectiveBackground = widget.isDisabled
        ? AppColors.surfaceSecondary
        : widget.isSelected
            ? AppColors.primarySurface
            : (widget.backgroundColor ?? AppColors.surface);

    final Border effectiveBorder = widget.border ??
        Border.all(
          color: widget.isSelected ? AppColors.primary : AppColors.border,
          width: widget.isSelected ? 1.5 : 1.0,
        );

    final List<BoxShadow> effectiveShadow = widget.shadow ??
        (widget.isSelected || widget.isDisabled ? AppElevation.none : AppElevation.small);

    final Widget cardBody = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      padding: widget.padding ?? const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: AppDimensions.cardRadius,
        border: effectiveBorder,
        boxShadow: effectiveShadow,
      ),
      child: widget.child,
    );

    if (canTap) {
      return AnimatedScale(
        scale: _isPressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 120),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap?.call();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: cardBody,
        ),
      );
    }

    return cardBody;
  }
}
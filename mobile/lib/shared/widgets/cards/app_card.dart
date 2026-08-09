import 'package:flutter/material.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_elevation.dart';

/// Reusable Standard Card Component in TripCraft.
class AppCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final Color effectiveBackground = isDisabled
        ? AppColors.surfaceSecondary
        : isSelected
            ? AppColors.primarySurface
            : (backgroundColor ?? AppColors.surface);

    final Border effectiveBorder = border ??
        Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1.0,
        );

    final List<BoxShadow> effectiveShadow = shadow ??
        (isSelected || isDisabled ? AppElevation.none : AppElevation.small);

    final Widget cardBody = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: padding ?? const EdgeInsets.all(AppDimensions.space16),
      decoration: BoxDecoration(
        color: effectiveBackground,
        borderRadius: AppDimensions.cardRadius,
        border: effectiveBorder,
        boxShadow: effectiveShadow,
      ),
      child: child,
    );

    if (onTap != null && !isDisabled) {
      return Material(
        color: Colors.transparent,
        borderRadius: AppDimensions.cardRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDimensions.cardRadius,
          child: cardBody,
        ),
      );
    }

    return cardBody;
  }
}
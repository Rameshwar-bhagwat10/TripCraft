import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../app/app_colors.dart';
import '../../../app/app_dimensions.dart';
import '../../../app/app_typography.dart';

enum AppChipVariant {
  standard,
  selected,
  outlined,
  success,
  warning,
  ai,
}

/// Reusable iOS-style Chip Component for TripCraft categories and filters.
class AppChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final Widget? icon;
  final AppChipVariant variant;

  const AppChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
    this.variant = AppChipVariant.standard,
  });

  @override
  State<AppChip> createState() => _AppChipState();
}

class _AppChipState extends State<AppChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide border = BorderSide.none;

    final effectiveVariant = widget.isSelected ? AppChipVariant.selected : widget.variant;

    switch (effectiveVariant) {
      case AppChipVariant.selected:
        bg = AppColors.primarySurface;
        fg = AppColors.primary;
        border = const BorderSide(color: AppColors.primary, width: 1.5);
        break;
      case AppChipVariant.outlined:
        bg = Colors.transparent;
        fg = AppColors.textSecondary;
        border = const BorderSide(color: AppColors.border, width: 1.0);
        break;
      case AppChipVariant.success:
        bg = AppColors.successLight;
        fg = AppColors.success;
        break;
      case AppChipVariant.warning:
        bg = AppColors.warningLight;
        fg = AppColors.warning;
        break;
      case AppChipVariant.ai:
        bg = AppColors.aiAccentLight;
        fg = AppColors.aiAccent;
        break;
      case AppChipVariant.standard:
        bg = AppColors.surface;
        fg = AppColors.textPrimary;
        border = const BorderSide(color: AppColors.border, width: 1.0);
        break;
    }

    final Widget chipContent = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.space14,
        vertical: AppDimensions.space10,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppDimensions.borderPill,
        border: border != BorderSide.none ? Border.fromBorderSide(border) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            IconTheme(
              data: IconThemeData(size: 16, color: fg),
              child: widget.icon!,
            ),
            const SizedBox(width: AppDimensions.space6),
          ],
          Text(
            widget.label,
            style: AppTypography.labelMedium.copyWith(
              color: fg,
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          if (widget.isSelected) ...[
            const SizedBox(width: AppDimensions.space6),
            Icon(
              PhosphorIconsBold.check,
              size: 14,
              color: fg,
            ),
          ],
        ],
      ),
    );

    if (widget.onTap != null) {
      return AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap?.call();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: chipContent,
        ),
      );
    }

    return chipContent;
  }
}

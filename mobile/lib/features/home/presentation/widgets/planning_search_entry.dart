import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';

/// Reusable Planning & Destination Search Entry Surface for TripCraft Home.
class PlanningSearchEntry extends StatefulWidget {
  final VoidCallback? onTap;

  const PlanningSearchEntry({
    super.key,
    this.onTap,
  });

  @override
  State<PlanningSearchEntry> createState() => _PlanningSearchEntryState();
}

class _PlanningSearchEntryState extends State<PlanningSearchEntry> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.space16,
          vertical: AppDimensions.space14,
        ),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.surfaceSecondary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              PhosphorIconsRegular.magnifyingGlass,
              color: AppColors.primary,
              size: 20,
            ),
            const SizedBox(width: AppDimensions.space12),
            Expanded(
              child: Text(
                'Where do you want to go next?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                PhosphorIconsBold.slidersHorizontal,
                color: AppColors.primary,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

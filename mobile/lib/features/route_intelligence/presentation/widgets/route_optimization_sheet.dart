import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../domain/services/route_intelligence_service.dart';

class RouteOptimizationSheet extends StatelessWidget {
  final OptimizationResultData result;
  final VoidCallback onApply;

  const RouteOptimizationSheet({
    super.key,
    required this.result,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: AppDimensions.space16,
        left: AppDimensions.pageMargin,
        right: AppDimensions.pageMargin,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppDimensions.space24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(PhosphorIconsFill.sparkle, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppDimensions.space12),
              Text('Route Optimization Preview', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          // Savings Banner
          Container(
            padding: const EdgeInsets.all(AppDimensions.space16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF0D9488)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('ESTIMATED TIME SAVED', style: AppTypography.labelSmall.copyWith(color: Colors.white70, fontSize: 10)),
                    const SizedBox(height: 4),
                    Text('${result.timeSavingsMins} mins', style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                  ],
                ),
                Container(width: 1, height: 32, color: Colors.white24),
                Column(
                  children: [
                    Text('DISTANCE REDUCTION', style: AppTypography.labelSmall.copyWith(color: Colors.white70, fontSize: 10)),
                    const SizedBox(height: 4),
                    Text('${result.distanceSavingsKm} km', style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space16),

          Text(result.explanation, style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4)),
          const SizedBox(height: AppDimensions.space24),

          PrimaryButton(
            label: 'Apply Optimized Sequence',
            icon: const Icon(PhosphorIconsBold.check, size: 18),
            onPressed: onApply,
          ),
        ],
      ),
    );
  }
}

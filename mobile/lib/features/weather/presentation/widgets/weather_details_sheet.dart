import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../smart_trip_intelligence/domain/entities/trip_readiness.dart';

class WeatherDetailsSheet extends StatelessWidget {
  final String activityTitle;
  final String time;
  final String weatherSummary;
  final int rainProbability;
  final List<AlternativeActivity> alternatives;
  final VoidCallback? onSubstitute;

  const WeatherDetailsSheet({
    super.key,
    required this.activityTitle,
    required this.time,
    required this.weatherSummary,
    required this.rainProbability,
    this.alternatives = const [],
    this.onSubstitute,
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
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(PhosphorIconsFill.cloudRain, color: AppColors.error, size: 20),
              ),
              const SizedBox(width: AppDimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weather Impact Analysis', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
                    Text('$activityTitle ($time)', style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space16),

          // Weather Impact Banner
          Container(
            padding: const EdgeInsets.all(AppDimensions.space14),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Icon(PhosphorIconsFill.warning, color: AppColors.error, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$weatherSummary ($rainProbability% probability). Outdoor activity may be affected by rain.',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textPrimary, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space20),

          if (alternatives.isNotEmpty) ...[
            Text('INDOOR RAIN-SAFE ALTERNATIVES', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
            const SizedBox(height: AppDimensions.space10),

            ...alternatives.map((alt) {
              return Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.space10),
                padding: const EdgeInsets.all(AppDimensions.space12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(PhosphorIconsFill.checkCircle, color: Color(0xFF10B981), size: 18),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(alt.name, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                          Text(alt.suitabilityReason, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: AppDimensions.space16),
          ],

          PrimaryButton(
            label: 'Substitute with Indoor Alternative',
            icon: const Icon(PhosphorIconsBold.arrowsLeftRight, size: 18),
            onPressed: () {
              Navigator.pop(context);
              onSubstitute?.call();
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/route_insight.dart';

class RouteInsightCard extends StatelessWidget {
  final RouteInsight insight;
  final VoidCallback? onAction;

  const RouteInsightCard({
    super.key,
    required this.insight,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final severityConfig = InsightSeverityConfig.getConfig(insight.severity);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.space12),
      padding: const EdgeInsets.all(AppDimensions.space14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: severityConfig.color.withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.02),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: severityConfig.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(severityConfig.icon, color: severityConfig.color, size: 18),
              ),
              const SizedBox(width: AppDimensions.space10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.title,
                      style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      severityConfig.label,
                      style: AppTypography.labelSmall.copyWith(
                        color: severityConfig.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              if (insight.estimatedTimeSavedMins != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Save ${insight.estimatedTimeSavedMins}m',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.space10),
          Text(
            insight.description,
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4),
          ),
          if (insight.recommendedAction != null) ...[
            const SizedBox(height: AppDimensions.space10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    insight.recommendedAction!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (onAction != null)
                  TextButton.icon(
                    onPressed: onAction,
                    icon: const Icon(PhosphorIconsRegular.arrowRight, size: 14),
                    label: const Text('Review', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

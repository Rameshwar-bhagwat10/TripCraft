import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/trip_readiness.dart';

class TripReadinessCard extends StatelessWidget {
  final TripReadiness readiness;

  const TripReadinessCard({
    super.key,
    required this.readiness,
  });

  @override
  Widget build(BuildContext context) {
    final statusConfig = ReadinessStatusConfig.getConfig(readiness.status);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.space20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TRIP READINESS & HEALTH',
                style: AppTypography.labelSmall.copyWith(color: Colors.white70, letterSpacing: 1.0),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusConfig.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusConfig.color.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(statusConfig.icon, size: 14, color: statusConfig.color),
                    const SizedBox(width: 6),
                    Text(
                      statusConfig.label.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: statusConfig.color,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space12),
          Text(
            readiness.summary,
            style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700, height: 1.3),
          ),
          const SizedBox(height: AppDimensions.space20),

          // Factors Breakdown Grid
          Container(
            padding: const EdgeInsets.all(AppDimensions.space12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildFactorItem(PhosphorIconsRegular.cloudSun, readiness.weatherFactorLabel, readiness.isWeatherWarning)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFactorItem(PhosphorIconsRegular.navigationArrow, readiness.routeFactorLabel, readiness.isRouteWarning)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _buildFactorItem(PhosphorIconsRegular.clock, readiness.scheduleFactorLabel, readiness.isScheduleWarning)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildFactorItem(PhosphorIconsRegular.checkSquare, readiness.activityFactorLabel, readiness.isActivityWarning)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFactorItem(IconData icon, String label, bool isWarning) {
    final color = isWarning ? Colors.orange : const Color(0xFF10B981);

    return Row(
      children: [
        Icon(isWarning ? PhosphorIconsFill.warning : PhosphorIconsFill.checkCircle, size: 14, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            label,
            style: AppTypography.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

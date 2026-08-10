import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/travel_document.dart';

class OperationalReadinessCard extends StatelessWidget {
  final TripOperationsSummary summary;

  const OperationalReadinessCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final isReady = summary.readinessStatus == 'ready';
    final statusColor = isReady ? const Color(0xFF10B981) : Colors.orange;

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
                'TRIP OPERATIONAL READINESS',
                style: AppTypography.labelSmall.copyWith(color: Colors.white70, letterSpacing: 1.0),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    Icon(isReady ? PhosphorIconsFill.checkCircle : PhosphorIconsFill.warning, size: 14, color: statusColor),
                    const SizedBox(width: 6),
                    Text(
                      '${summary.readinessScore}% READINESS',
                      style: AppTypography.labelSmall.copyWith(color: statusColor, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.space12),
          Text(
            summary.summary,
            style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700, height: 1.3),
          ),
          const SizedBox(height: AppDimensions.space16),

          Row(
            children: [
              Expanded(
                child: _buildMetricItem(PhosphorIconsRegular.ticket, '${summary.confirmedBookingsCount}/${summary.totalBookings}', 'Bookings Confirmed'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricItem(PhosphorIconsRegular.fileText, '${summary.totalDocumentsCount}', 'Travel Tickets Vault'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.space10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: AppTypography.titleSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                Text(label, style: AppTypography.bodySmall.copyWith(color: Colors.white70, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

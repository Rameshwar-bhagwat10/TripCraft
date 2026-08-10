import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/booking.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onTap;

  const BookingCard({
    super.key,
    required this.booking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final typeConfig = BookingTypeConfig.getConfig(booking.type);
    final statusConfig = BookingStatusConfig.getConfig(booking.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.space16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: typeConfig.color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(typeConfig.icon, color: typeConfig.color, size: 20),
            ),
            const SizedBox(width: AppDimensions.space14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        typeConfig.label.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(color: typeConfig.color, fontWeight: FontWeight.w800, fontSize: 10),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusConfig.color.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statusConfig.label,
                          style: AppTypography.labelSmall.copyWith(
                            color: statusConfig.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    booking.title,
                    style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${booking.providerName} · Ref: ${booking.confirmationNumber}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

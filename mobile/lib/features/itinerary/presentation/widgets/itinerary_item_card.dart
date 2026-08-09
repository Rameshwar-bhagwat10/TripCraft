import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/itinerary.dart';

/// Reusable Activity Item Card for Visual Timeline.
class ItineraryItemCard extends StatelessWidget {
  final ItineraryItem item;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onMove;
  final VoidCallback? onDelete;

  const ItineraryItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onEdit,
    this.onMove,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final typeConfig = ActivityTypeConfig.getConfig(item.type);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.space14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.02),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Icon Badge
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: typeConfig.tintColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                typeConfig.icon,
                color: typeConfig.tintColor,
                size: 20,
              ),
            ),
            const SizedBox(width: AppDimensions.space12),

            // Content Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: AppTypography.titleSmall.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(
                          PhosphorIconsBold.dotsThree,
                          color: AppColors.textTertiary,
                          size: 18,
                        ),
                        onSelected: (value) {
                          if (value == 'edit') onEdit?.call();
                          if (value == 'move') onMove?.call();
                          if (value == 'delete') onDelete?.call();
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(PhosphorIconsRegular.pencilSimple, size: 16),
                                SizedBox(width: 8),
                                Text('Edit Activity'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'move',
                            child: Row(
                              children: [
                                Icon(PhosphorIconsRegular.arrowsLeftRight, size: 16),
                                SizedBox(width: 8),
                                Text('Move to Another Day'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(PhosphorIconsRegular.trash, size: 16, color: AppColors.error),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: AppColors.error)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (item.description != null && item.description!.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.description!,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppDimensions.space8),

                  // Metadata Badges Row (Time, Duration, Category)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSecondary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(PhosphorIconsRegular.clock, size: 12, color: AppColors.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              item.isAllDay
                                  ? 'ALL DAY'
                                  : '${item.startTime ?? "09:00"} - ${item.endTime ?? "10:30"}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.duration != null && !item.isAllDay) ...[
                        const SizedBox(width: 6),
                        Text(
                          '(${item.duration})',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textTertiary,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
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

import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/trip.dart';
import 'trip_status_badge.dart';

/// Reusable Premium Trip Card for Trips Tab.
class TripCard extends StatelessWidget {
  final Trip trip;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onArchive;
  final VoidCallback? onRestore;
  final VoidCallback? onDelete;

  const TripCard({
    super.key,
    required this.trip,
    this.onTap,
    this.onEdit,
    this.onArchive,
    this.onRestore,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final locationText = trip.destination != null
        ? '${trip.destination!.city}, ${trip.destination!.country}'
        : 'Destination';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.03),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image with Status Badge & Options Menu
              Stack(
                children: [
                  Image.network(
                    trip.coverImage,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: AppColors.surfaceSecondary,
                      child: const Center(
                        child: Icon(
                          PhosphorIconsRegular.image,
                          color: AppColors.textTertiary,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: TripStatusBadge(status: trip.status),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: PopupMenuButton<String>(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.1),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Icon(
                          PhosphorIconsBold.dotsThree,
                          color: AppColors.textPrimary,
                          size: 18,
                        ),
                      ),
                      onSelected: (value) {
                        if (value == 'edit') onEdit?.call();
                        if (value == 'archive') onArchive?.call();
                        if (value == 'restore') onRestore?.call();
                        if (value == 'delete') onDelete?.call();
                      },
                      itemBuilder: (context) => [
                        if (trip.status != TripStatus.archived) ...[
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(PhosphorIconsRegular.pencilSimple, size: 16),
                                SizedBox(width: 8),
                                Text('Edit Trip'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'archive',
                            child: Row(
                              children: [
                                Icon(PhosphorIconsRegular.archive, size: 16),
                                SizedBox(width: 8),
                                Text('Archive Trip'),
                              ],
                            ),
                          ),
                        ] else ...[
                          const PopupMenuItem(
                            value: 'restore',
                            child: Row(
                              children: [
                                Icon(PhosphorIconsRegular.arrowCounterClockwise, size: 16),
                                SizedBox(width: 8),
                                Text('Restore Trip'),
                              ],
                            ),
                          ),
                        ],
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(PhosphorIconsRegular.trash, size: 16, color: AppColors.error),
                              SizedBox(width: 8),
                              Text('Delete Trip', style: TextStyle(color: AppColors.error)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Details Body
              Padding(
                padding: const EdgeInsets.all(AppDimensions.space16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.title,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          PhosphorIconsRegular.mapPin,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          locationText,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.space12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              PhosphorIconsRegular.calendar,
                              size: 14,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${trip.startDate} — ${trip.endDate}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              PhosphorIconsRegular.users,
                              size: 14,
                              color: AppColors.textTertiary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${trip.travelersCount}',
                              style: AppTypography.labelSmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
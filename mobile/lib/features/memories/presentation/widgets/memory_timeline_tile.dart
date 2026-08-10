import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../domain/entities/trip_photo.dart';
import 'photo_tile.dart';

class MemoryTimelineTile extends StatelessWidget {
  final MemoryTimelineDay day;
  final Function(TripPhoto photo) onPhotoTap;

  const MemoryTimelineTile({
    super.key,
    required this.day,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'DAY ${day.dayNumber}',
                style: AppTypography.labelSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              day.dateTitle,
              style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(PhosphorIconsRegular.mapPin, size: 12, color: AppColors.textTertiary),
                const SizedBox(width: 4),
                Text(
                  day.locationTitle,
                  style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.space12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1.0,
          ),
          itemCount: day.photos.length,
          itemBuilder: (context, index) {
            final photo = day.photos[index];
            return PhotoTile(
              photo: photo,
              onTap: () => onPhotoTap(photo),
            );
          },
        ),
        const SizedBox(height: AppDimensions.space24),
      ],
    );
  }
}

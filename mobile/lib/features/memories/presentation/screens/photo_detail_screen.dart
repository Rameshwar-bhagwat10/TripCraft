import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../providers/trip_memories_provider.dart';

class PhotoDetailScreen extends ConsumerWidget {
  final String tripId;
  final String photoId;

  const PhotoDetailScreen({
    super.key,
    required this.tripId,
    required this.photoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripMemoriesProvider(tripId));
    final photo = state.photos.firstWhere((p) => p.id == photoId, orElse: () => state.photos.first);

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Photo Details & EXIF', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.pageMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: Image.network(photo.thumbnailPath, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: AppDimensions.space20),

            Text('PHOTO METADATA', style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0)),
            const SizedBox(height: 8),

            _buildDetailTile('Caption', photo.caption ?? 'None', PhosphorIconsRegular.textT),
            _buildDetailTile('Location Name', photo.locationName ?? 'Goa, India', PhosphorIconsRegular.mapPin),
            _buildDetailTile('Coordinates', '${photo.latitude?.toStringAsFixed(4)}, ${photo.longitude?.toStringAsFixed(4)}', PhosphorIconsRegular.globe),
            _buildDetailTile('Capture Timestamp', photo.takenAt, PhosphorIconsRegular.clock),
            _buildDetailTile('File Dimensions', '${photo.width} × ${photo.height} px', PhosphorIconsRegular.frameCorners),
            _buildDetailTile('File Size', '${(photo.fileSizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB', PhosphorIconsRegular.hardDrive),
            _buildDetailTile('Trip Day', 'Day ${photo.tripDay}', PhosphorIconsRegular.calendar),
            _buildDetailTile('Favorite Memory', photo.isFavorite ? 'Yes' : 'No', PhosphorIconsRegular.heart),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary, fontSize: 11)),
              Text(value, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

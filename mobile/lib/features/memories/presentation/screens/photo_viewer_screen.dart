import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../providers/trip_memories_provider.dart';

class PhotoViewerScreen extends ConsumerWidget {
  final String tripId;
  final String photoId;

  const PhotoViewerScreen({
    super.key,
    required this.tripId,
    required this.photoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripMemoriesProvider(tripId));
    final notifier = ref.read(tripMemoriesProvider(tripId).notifier);
    final photo = state.photos.firstWhere((p) => p.id == photoId, orElse: () => state.photos.first);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Full Screen Image Pinch-Zoom
            Center(
              child: InteractiveViewer(
                minScale: 0.8,
                maxScale: 4.0,
                child: Image.network(
                  photo.previewPath,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(PhosphorIconsRegular.image, size: 64, color: Colors.white54),
                      SizedBox(height: 8),
                      Text('Image unavailable', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),
              ),
            ),

            // Top Bar Controls
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(PhosphorIconsRegular.arrowLeft, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: Icon(
                            photo.isFavorite ? PhosphorIconsFill.heart : PhosphorIconsRegular.heart,
                            color: photo.isFavorite ? Colors.redAccent : Colors.white,
                          ),
                          onPressed: () => notifier.toggleFavorite(photo.id),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: const Icon(PhosphorIconsRegular.info, color: Colors.white),
                          onPressed: () => context.push('/trips/$tripId/photos/${photo.id}/details'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        backgroundColor: Colors.black45,
                        child: IconButton(
                          icon: const Icon(PhosphorIconsRegular.trash, color: AppColors.error),
                          onPressed: () async {
                            await notifier.deletePhoto(photo.id);
                            if (context.mounted) {
                              AppSnackBar.show(context, message: 'Photo deleted');
                              context.pop();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom Caption Overlay
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.space16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (photo.caption != null)
                      Text(
                        photo.caption!,
                        style: AppTypography.titleMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(PhosphorIconsRegular.mapPin, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          photo.locationName ?? 'Goa, India',
                          style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                        ),
                        const Spacer(),
                        const Icon(PhosphorIconsRegular.calendar, size: 14, color: Colors.white54),
                        const SizedBox(width: 4),
                        Text(
                          'Day ${photo.tripDay}',
                          style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

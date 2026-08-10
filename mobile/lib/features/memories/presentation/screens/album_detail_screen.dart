import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../providers/trip_memories_provider.dart';
import '../widgets/photo_tile.dart';

class AlbumDetailScreen extends ConsumerWidget {
  final String tripId;
  final String albumId;

  const AlbumDetailScreen({
    super.key,
    required this.tripId,
    required this.albumId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripMemoriesProvider(tripId));
    final album = state.albums.firstWhere((a) => a.id == albumId, orElse: () => state.albums.first);
    final albumPhotos = state.photos.where((p) => p.albumIds.contains(album.id)).toList();

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(album.title, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
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
                aspectRatio: 1.8,
                child: Image.network(album.coverPhotoUrl, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: AppDimensions.space16),

            Text(
              album.title,
              style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w800),
            ),
            if (album.description != null) ...[
              const SizedBox(height: 4),
              Text(
                album.description!,
                style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
            const SizedBox(height: AppDimensions.space20),

            Text(
              'COLLECTION PHOTOS (${albumPhotos.length})',
              style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0),
            ),
            const SizedBox(height: 8),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: albumPhotos.isNotEmpty ? albumPhotos.length : state.photos.length,
              itemBuilder: (context, index) {
                final photo = albumPhotos.isNotEmpty ? albumPhotos[index] : state.photos[index];
                return PhotoTile(
                  photo: photo,
                  onTap: () => context.push('/trips/$tripId/photos/${photo.id}'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../providers/trip_memories_provider.dart';
import '../widgets/add_photo_sheet.dart';
import '../widgets/album_card.dart';
import '../widgets/create_album_sheet.dart';
import '../widgets/memory_timeline_tile.dart';
import '../widgets/photo_tile.dart';

class MemoriesOverviewScreen extends ConsumerWidget {
  final String tripId;

  const MemoriesOverviewScreen({
    super.key,
    required this.tripId,
  });

  void _showAddPhotoSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddPhotoSheet(
        onSubmit: (data) async {
          await ref.read(tripMemoriesProvider(tripId).notifier).createPhoto(data);
          if (context.mounted) {
            AppSnackBar.show(context, message: 'Photo uploaded');
          }
        },
      ),
    );
  }

  void _showCreateAlbumSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateAlbumSheet(
        onSubmit: (data) async {
          await ref.read(tripMemoriesProvider(tripId).notifier).createAlbum(data);
          if (context.mounted) {
            AppSnackBar.show(context, message: 'Album created');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripMemoriesProvider(tripId));
    final notifier = ref.read(tripMemoriesProvider(tripId).notifier);
    final summary = state.summary;

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Trip Memories & Story', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsRegular.plus, color: AppColors.primary),
            onPressed: () => _showAddPhotoSheet(context, ref),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.pageMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Story Banner
                  Container(
                    padding: const EdgeInsets.all(AppDimensions.space20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(PhosphorIconsFill.image, color: Colors.amber, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'TRIP STORY METRICS',
                              style: AppTypography.labelSmall.copyWith(color: Colors.white70, letterSpacing: 1.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  '${summary?.totalPhotosCount ?? 0}',
                                  style: AppTypography.displaySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                                ),
                                Text('Photos', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                              ],
                            ),
                            Container(width: 1, height: 32, color: Colors.white24),
                            Column(
                              children: [
                                Text(
                                  '${summary?.totalPlacesPhotographed ?? 0}',
                                  style: AppTypography.displaySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
                                ),
                                Text('Places', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                              ],
                            ),
                            Container(width: 1, height: 32, color: Colors.white24),
                            Column(
                              children: [
                                Text(
                                  '${summary?.favoritePhotosCount ?? 0}',
                                  style: AppTypography.displaySmall.copyWith(color: Colors.amber, fontWeight: FontWeight.w800),
                                ),
                                Text('Favorites', style: AppTypography.bodySmall.copyWith(color: Colors.white70)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space20),

                  // Segment Control Bar
                  Row(
                    children: [
                      _buildSegmentChip('Photos', 'photos', state.activeSegment, notifier),
                      const SizedBox(width: 8),
                      _buildSegmentChip('Albums', 'albums', state.activeSegment, notifier),
                      const SizedBox(width: 8),
                      _buildSegmentChip('Timeline', 'timeline', state.activeSegment, notifier),
                      const SizedBox(width: 8),
                      _buildSegmentChip('Map View', 'map', state.activeSegment, notifier),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space20),

                  // Segment Contents
                  if (state.activeSegment == 'photos') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ALL MEMORIES (${state.photos.length})',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0),
                        ),
                        IconButton(
                          icon: const Icon(PhosphorIconsRegular.plusCircle, color: AppColors.primary, size: 20),
                          onPressed: () => _showAddPhotoSheet(context, ref),
                        ),
                      ],
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
                      itemCount: state.photos.length,
                      itemBuilder: (context, index) {
                        final photo = state.photos[index];
                        return PhotoTile(
                          photo: photo,
                          onTap: () => context.push('/trips/$tripId/photos/${photo.id}'),
                          onFavoriteToggle: () => notifier.toggleFavorite(photo.id),
                        );
                      },
                    ),
                  ] else if (state.activeSegment == 'albums') ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'PHOTO ALBUMS (${state.albums.length})',
                          style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0),
                        ),
                        TextButton.icon(
                          onPressed: () => _showCreateAlbumSheet(context, ref),
                          icon: const Icon(PhosphorIconsRegular.folderPlus, size: 16, color: AppColors.primary),
                          label: const Text('New Album'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.albums.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final album = state.albums[index];
                        return AlbumCard(
                          album: album,
                          onTap: () => context.push('/trips/$tripId/albums/${album.id}'),
                        );
                      },
                    ),
                  ] else if (state.activeSegment == 'timeline') ...[
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.timelineDays.length,
                      itemBuilder: (context, index) {
                        final day = state.timelineDays[index];
                        return MemoryTimelineTile(
                          day: day,
                          onPhotoTap: (photo) => context.push('/trips/$tripId/photos/${photo.id}'),
                        );
                      },
                    ),
                  ] else if (state.activeSegment == 'map') ...[
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: Color.fromRGBO(0, 0, 0, 0) == Colors.transparent ? MainAxisAlignment.center : MainAxisAlignment.center,
                        children: [
                          const Icon(PhosphorIconsBold.mapPin, size: 40, color: AppColors.primary),
                          const SizedBox(height: 10),
                          Text('Spatial Photo Map', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(
                            '${state.mapPoints.length} Geotagged photo locations in North Goa',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 14),
                          ElevatedButton.icon(
                            onPressed: () => context.push('/trips/$tripId/memories/map'),
                            icon: const Icon(PhosphorIconsBold.globe, size: 16),
                            label: const Text('Open Interactive Photo Map'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: AppDimensions.space32),
                ],
              ),
            ),
    );
  }

  Widget _buildSegmentChip(String label, String value, String activeSegment, TripMemoriesNotifier notifier) {
    final isSelected = activeSegment == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => notifier.setActiveSegment(value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? Colors.white : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

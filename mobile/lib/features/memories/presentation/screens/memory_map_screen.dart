import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../providers/trip_memories_provider.dart';

class MemoryMapScreen extends ConsumerWidget {
  final String tripId;

  const MemoryMapScreen({
    super.key,
    required this.tripId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tripMemoriesProvider(tripId));

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text('Spatial Photo Map', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Map Canvas Simulator
          Expanded(
            child: Container(
              color: AppColors.surfaceSecondary,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(PhosphorIconsBold.globe, size: 64, color: AppColors.primary),
                        const SizedBox(height: 12),
                        Text('North Goa Geotagged Clusters', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),

                  // Simulated Geotag Pin 1
                  Positioned(
                    top: 140,
                    left: 90,
                    child: _buildMapPin(context, state.mapPoints.isNotEmpty ? state.mapPoints[0] : null, tripId),
                  ),

                  // Simulated Geotag Pin 2
                  Positioned(
                    top: 240,
                    right: 80,
                    child: _buildMapPin(context, state.mapPoints.length > 1 ? state.mapPoints[1] : null, tripId),
                  ),
                ],
              ),
            ),
          ),

          // Bottom List of Geotagged Locations
          Container(
            padding: const EdgeInsets.all(AppDimensions.pageMargin),
            color: AppColors.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GEOTAGGED LOCATIONS (${state.mapPoints.length})',
                  style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary, letterSpacing: 1.0),
                ),
                const SizedBox(height: 8),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.mapPoints.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final pt = state.mapPoints[index];
                    return ListTile(
                      tileColor: AppColors.surface,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: AppColors.border)),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(pt.coverPhotoUrl, width: 40, height: 40, fit: BoxFit.cover),
                      ),
                      title: Text(pt.locationName, style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700)),
                      subtitle: Text('${pt.latitude.toStringAsFixed(4)}, ${pt.longitude.toStringAsFixed(4)}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(10)),
                        child: Text('${pt.photoCount} Photos', style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(BuildContext context, dynamic mapPoint, String tripId) {
    if (mapPoint == null) return const SizedBox.shrink();
    return GestureDetector(
      onTap: () {
        if (mapPoint.photos != null && mapPoint.photos.isNotEmpty) {
          context.push('/trips/$tripId/photos/${mapPoint.photos[0].id}');
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(mapPoint.coverPhotoUrl, width: 48, height: 48, fit: BoxFit.cover),
            ),
          ),
          const Icon(PhosphorIconsFill.caretDown, color: Colors.white, size: 16),
        ],
      ),
    );
  }
}

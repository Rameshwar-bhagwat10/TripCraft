import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../memories/domain/entities/trip_photo.dart';
import '../../../memories/presentation/widgets/album_card.dart';
import '../../../memories/presentation/widgets/photo_tile.dart';

class MemoriesComponentsSection extends StatelessWidget {
  const MemoriesComponentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TRIP MEMORIES & PHOTOS COMPONENTS',
          style: AppTypography.labelSmall.copyWith(color: Colors.grey[600], letterSpacing: 1.2),
        ),
        const SizedBox(height: AppDimensions.space12),

        SizedBox(
          height: 140,
          child: PhotoTile(
            photo: TripPhoto(
              id: 'demo-photo',
              tripId: 'demo-trip',
              userId: 'demo-user',
              storagePath: 'demo.jpg',
              thumbnailPath: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=400',
              previewPath: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=1200',
              fileName: 'demo.jpg',
              fileSizeBytes: 2000000,
              width: 3000,
              height: 2000,
              caption: 'Demo Sunset Memory',
              takenAt: DateTime.now().toIso8601String(),
              uploadedAt: DateTime.now().toIso8601String(),
              isFavorite: true,
            ),
            onTap: () {},
          ),
        ),
        const SizedBox(height: AppDimensions.space12),

        AlbumCard(
          album: PhotoAlbum(
            id: 'demo-album',
            tripId: 'demo-trip',
            userId: 'demo-user',
            title: 'Beach Sunsets Collection',
            description: 'Golden hour photos from North Goa beaches',
            coverPhotoUrl: 'https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?w=600',
            photoCount: 14,
            createdAt: DateTime.now().toIso8601String(),
          ),
          onTap: () {},
        ),
      ],
    );
  }
}

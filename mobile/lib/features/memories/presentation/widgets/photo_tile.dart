import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../domain/entities/trip_photo.dart';

class PhotoTile extends StatelessWidget {
  final TripPhoto photo;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  const PhotoTile({
    super.key,
    required this.photo,
    required this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              photo.thumbnailPath,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: AppColors.surfaceSecondary,
                child: const Icon(PhosphorIconsRegular.image, color: AppColors.textTertiary, size: 28),
              ),
            ),

            // Favorite Badge
            if (photo.isFavorite)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(0, 0, 0, 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(PhosphorIconsFill.heart, color: Colors.redAccent, size: 14),
                  ),
                ),
              ),

            // Caption overlay gradient
            if (photo.caption != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Text(
                    photo.caption!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

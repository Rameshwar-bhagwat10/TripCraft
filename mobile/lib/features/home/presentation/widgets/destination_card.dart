import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../explore/domain/entities/destination.dart';
import '../../domain/entities/home_data.dart';

/// Reusable Recommendation & Destination Card for Horizontal Carousels & Grids.
class DestinationCard extends StatelessWidget {
  final String title;
  final String location;
  final String imageUrl;
  final bool isSaved;
  final VoidCallback? onTap;
  final VoidCallback? onSaveTap;

  DestinationCard({
    super.key,
    required RecommendedDestination destination,
    this.onTap,
    this.onSaveTap,
  })  : title = destination.title,
        location = destination.location,
        imageUrl = destination.imageUrl,
        isSaved = destination.isSaved;

  factory DestinationCard.fromDestination({
    Key? key,
    required Destination destination,
    VoidCallback? onTap,
    VoidCallback? onSaveTap,
  }) {
    return DestinationCard._raw(
      key: key,
      title: destination.name,
      location: '${destination.city}, ${destination.country}',
      imageUrl: destination.heroImage,
      isSaved: destination.isSaved,
      onTap: onTap,
      onSaveTap: onSaveTap,
    );
  }

  const DestinationCard._raw({
    super.key,
    required this.title,
    required this.location,
    required this.imageUrl,
    required this.isSaved,
    this.onTap,
    this.onSaveTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
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
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    imageUrl,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      color: AppColors.surfaceSecondary,
                      child: const Center(
                        child: Icon(
                          PhosphorIconsRegular.image,
                          color: AppColors.textTertiary,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onSaveTap,
                      child: Container(
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
                        child: Icon(
                          isSaved
                              ? PhosphorIconsFill.bookmark
                              : PhosphorIconsRegular.bookmark,
                          color: isSaved
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.space12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
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
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            location,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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

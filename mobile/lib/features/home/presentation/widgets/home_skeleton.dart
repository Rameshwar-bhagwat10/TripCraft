import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/widgets/loading/skeleton_loader.dart';

/// Shimmer Skeleton Loader matching Home screen layout.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimensions.space16),

          // Greeting Header Skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonLoader.textLine(width: 100, height: 16),
                  const SizedBox(height: 8),
                  SkeletonLoader.textLine(width: 160, height: 28),
                ],
              ),
              SkeletonLoader.avatar(size: 44),
            ],
          ),
          const SizedBox(height: AppDimensions.space24),

          // Search Bar Skeleton
          SkeletonLoader(width: double.infinity, height: 52, borderRadius: BorderRadius.circular(16)),
          const SizedBox(height: AppDimensions.space24),

          // Trip Card Skeleton
          SkeletonLoader(width: double.infinity, height: 160, borderRadius: BorderRadius.circular(20)),
          const SizedBox(height: AppDimensions.space24),

          // Quick Actions Skeleton
          Row(
            children: [
              Expanded(child: SkeletonLoader(height: 64, borderRadius: BorderRadius.circular(16))),
              const SizedBox(width: 12),
              Expanded(child: SkeletonLoader(height: 64, borderRadius: BorderRadius.circular(16))),
              const SizedBox(width: 12),
              Expanded(child: SkeletonLoader(height: 64, borderRadius: BorderRadius.circular(16))),
            ],
          ),
          const SizedBox(height: AppDimensions.space28),

          // Recommendations Title Skeleton
          SkeletonLoader.textLine(width: 180, height: 20),
          const SizedBox(height: AppDimensions.space16),

          // Carousel Skeleton
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SkeletonLoader(width: 180, height: 180, borderRadius: BorderRadius.circular(16)),
                const SizedBox(width: 16),
                SkeletonLoader(width: 180, height: 180, borderRadius: BorderRadius.circular(16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../shared/layouts/section_layout.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/loading/loading_indicator.dart';
import '../../../../shared/widgets/loading/skeleton_loader.dart';
import '../../../../shared/widgets/states/empty_state.dart';
import '../../../../shared/widgets/states/error_state.dart';
import '../../../../shared/widgets/states/offline_state.dart';

class StateSection extends StatelessWidget {
  const StateSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionLayout(
      title: 'Loading & App States',
      subtitle: 'Progress spinners, skeleton loaders, empty, error, and offline cards',
      child: Column(
        children: [
          const AppCard(
            child: LoadingIndicator(message: 'Loading your travel itinerary...'),
          ),
          const SizedBox(height: AppDimensions.space12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkeletonLoader.avatar(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SkeletonLoader.textLine(width: 140),
                          const SizedBox(height: 6),
                          SkeletonLoader.textLine(width: 90, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SkeletonLoader.textLine(height: 48),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          const AppCard(
            child: EmptyState(
              title: 'No saved trips yet',
              description: 'Start exploring destinations to create your first trip itinerary.',
              actionLabel: 'Explore Destinations',
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          AppCard(
            child: ErrorState(
              onRetry: () {},
            ),
          ),
          const SizedBox(height: AppDimensions.space12),
          AppCard(
            child: OfflineState(
              onRetry: () {},
            ),
          ),
        ],
      ),
    );
  }
}

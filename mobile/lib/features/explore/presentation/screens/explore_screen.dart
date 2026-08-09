import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';
import '../../../../shared/widgets/states/empty_state.dart';

import '../../../home/presentation/widgets/destination_card.dart';
import '../providers/explore_provider.dart';
import '../widgets/category_selector.dart';
import '../widgets/explore_header.dart';
import '../widgets/explore_search_bar.dart';
import '../widgets/featured_destination_card.dart';
import '../widgets/filter_bottom_sheet.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exploreState = ref.watch(exploreProvider);
    final exploreNotifier = ref.read(exploreProvider.notifier);

    return AppScaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => exploreNotifier.loadExploreData(isRefresh: true),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.space16),

                // Header
                const ExploreHeader(),
                const SizedBox(height: AppDimensions.space20),

                // Search Bar
                ExploreSearchBar(
                  onTap: () => context.push('/explore/search'),
                  onFilterTap: () {
                    FilterBottomSheet.show(
                      context,
                      currentFilter: exploreState.filter,
                      onApply: (newFilter) => exploreNotifier.updateFilter(newFilter),
                    );
                  },
                  activeFilterCount: exploreState.filter.hasActiveFilters ? 1 : 0,
                ),
                const SizedBox(height: AppDimensions.space20),

                // Category Selector
                CategorySelector(
                  selectedCategory: exploreState.selectedCategory,
                  onCategorySelected: (cat) => exploreNotifier.selectCategory(cat),
                ),
                const SizedBox(height: AppDimensions.space24),

                // Filtered Results View if category or filter is active
                if (exploreState.filter.hasActiveFilters || exploreState.selectedCategory != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FILTERED RESULTS (${exploreState.filteredDestinations.length})',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textTertiary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => exploreNotifier.selectCategory(null),
                        child: Text(
                          'Clear Filter',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space12),
                  if (exploreState.filteredDestinations.isEmpty)
                    EmptyState(
                      title: 'No Matching Destinations',
                      description: 'Try clearing your category or filter selection to discover more places.',
                      actionLabel: 'Clear All Filters',
                      onAction: () => exploreNotifier.selectCategory(null),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.82,
                        crossAxisSpacing: AppDimensions.space12,
                        mainAxisSpacing: AppDimensions.space12,
                      ),
                      itemCount: exploreState.filteredDestinations.length,
                      itemBuilder: (context, index) {
                        final dest = exploreState.filteredDestinations[index];
                        return DestinationCard.fromDestination(
                          destination: dest,
                          onTap: () => context.push('/explore/destination/${dest.id}'),
                          onSaveTap: () {
                            exploreNotifier.toggleSaveDestination(dest.id);
                            AppSnackBar.show(
                              context,
                              message: dest.isSaved ? 'Removed from saved' : 'Saved to collection!',
                              variant: AppSnackBarVariant.info,
                            );
                          },
                        );
                      },
                    ),
                  const SizedBox(height: AppDimensions.space32),
                ] else ...[
                  // Featured Editorial Hero Section
                  if (exploreState.featured.isNotEmpty) ...[
                    _buildSectionTitle('FEATURED DESTINATIONS'),
                    FeaturedDestinationCard(
                      destination: exploreState.featured.first,
                      onTap: () => context.push('/explore/destination/${exploreState.featured.first.id}'),
                      onBookmarkTap: () {
                        exploreNotifier.toggleSaveDestination(exploreState.featured.first.id);
                      },
                    ),
                    const SizedBox(height: AppDimensions.space28),
                  ],

                  // Recommended Carousel
                  if (exploreState.recommended.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle('RECOMMENDED FOR YOU'),
                        GestureDetector(
                          onTap: () => context.push('/explore/search'),
                          child: Text(
                            'See all',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 200,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: exploreState.recommended.length,
                        separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.space12),
                        itemBuilder: (context, index) {
                          final dest = exploreState.recommended[index];
                          return DestinationCard.fromDestination(
                            destination: dest,
                            onTap: () => context.push('/explore/destination/${dest.id}'),
                            onSaveTap: () {
                              exploreNotifier.toggleSaveDestination(dest.id);
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space28),
                  ],

                  // Trending Destinations Grid
                  if (exploreState.trending.isNotEmpty) ...[
                    _buildSectionTitle('TRENDING NOW'),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.82,
                        crossAxisSpacing: AppDimensions.space12,
                        mainAxisSpacing: AppDimensions.space12,
                      ),
                      itemCount: exploreState.trending.length,
                      itemBuilder: (context, index) {
                        final dest = exploreState.trending[index];
                        return DestinationCard.fromDestination(
                          destination: dest,
                          onTap: () => context.push('/explore/destination/${dest.id}'),
                          onSaveTap: () {
                            exploreNotifier.toggleSaveDestination(dest.id);
                          },
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.space32),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.space12),
      child: Text(
        title,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
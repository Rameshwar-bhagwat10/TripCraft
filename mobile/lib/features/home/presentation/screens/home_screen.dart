import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../app/app_colors.dart';
import '../../../../app/app_dimensions.dart';
import '../../../../app/app_typography.dart';
import '../../../../core/constants/route_constants.dart';
import '../../../../shared/layouts/app_scaffold.dart';
import '../../../../shared/widgets/cards/app_card.dart';
import '../../../../shared/widgets/chips/app_chip.dart';
import '../../../../shared/widgets/feedback/app_snackbar.dart';

import '../../../profile/presentation/providers/profile_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/destination_card.dart';
import '../widgets/greeting_header.dart';
import '../widgets/home_skeleton.dart';
import '../widgets/planning_search_entry.dart';
import '../widgets/quick_action_tile.dart';
import '../widgets/upcoming_trip_card.dart';
import '../widgets/weather_preview_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final homeState = ref.watch(homeProvider);
    final homeNotifier = ref.read(homeProvider.notifier);

    final user = profileState.profile;
    final homeData = homeState.data;

    if (homeState.isLoading && homeData.recommendations.isEmpty) {
      return const AppScaffold(
        body: SafeArea(child: HomeSkeleton()),
      );
    }

    return AppScaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => homeNotifier.fetchHomeData(isRefresh: true),
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.pageMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.space16),

                // Greeting Header
                GreetingHeader(
                  fullName: user?.fullName,
                  avatarUrl: user?.avatarUrl,
                  onAvatarTap: () => context.push(RouteConstants.profile),
                ),
                const SizedBox(height: AppDimensions.space20),

                // Planning / Search Entry
                PlanningSearchEntry(
                  onTap: () => context.go('/explore'),
                ),
                const SizedBox(height: AppDimensions.space24),

                // Upcoming Trip or Activation CTA Card
                UpcomingTripCard(
                  trip: homeData.upcomingTrip,
                  onPlanTripTap: () => context.go('/trips'),
                  onViewTripTap: () => context.go('/trips'),
                ),
                const SizedBox(height: AppDimensions.space24),

                // Quick Actions Section
                _buildSectionTitle('QUICK ACTIONS'),
                Row(
                  children: [
                    Expanded(
                      child: QuickActionTile(
                        icon: PhosphorIconsBold.compass,
                        title: 'Plan Trip',
                        isPrimary: true,
                        onTap: () => context.go('/trips'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: QuickActionTile(
                        icon: PhosphorIconsRegular.magnifyingGlass,
                        title: 'Explore',
                        onTap: () => context.go('/explore'),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.space12),
                    Expanded(
                      child: QuickActionTile(
                        icon: PhosphorIconsRegular.bookmark,
                        title: 'Saved',
                        onTap: () => context.go('/saved'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimensions.space28),

                // Recommended For You Carousel
                if (homeData.recommendations.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionTitle('RECOMMENDED FOR YOU'),
                      GestureDetector(
                        onTap: () => context.go('/explore'),
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
                      itemCount: homeData.recommendations.length,
                      separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.space12),
                      itemBuilder: (context, index) {
                        final rec = homeData.recommendations[index];
                        return DestinationCard(
                          destination: rec,
                          onTap: () => context.go('/explore'),
                          onSaveTap: () {
                            homeNotifier.toggleSaveDestination(rec.id);
                            AppSnackBar.show(
                              context,
                              message: rec.isSaved ? 'Removed from saved' : 'Saved to collection!',
                              variant: AppSnackBarVariant.info,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space28),
                ],

                // Travel Inspiration Section
                if (homeData.inspiration.isNotEmpty) ...[
                  _buildSectionTitle('TRAVEL INSPIRATION'),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: homeData.inspiration.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppDimensions.space8),
                          child: AppChip(
                            label: item.title,
                            icon: const Icon(PhosphorIconsRegular.sparkle, size: 14),
                            onTap: () => context.go('/explore'),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space28),
                ],

                // Weather Preview Section
                if (homeData.weather != null) ...[
                  _buildSectionTitle('WEATHER PREVIEW'),
                  WeatherPreviewCard(weather: homeData.weather),
                  const SizedBox(height: AppDimensions.space28),
                ],

                // Recent Activity Section
                if (homeData.recentActivity.isNotEmpty) ...[
                  _buildSectionTitle('RECENT ACTIVITY'),
                  ...homeData.recentActivity.map((activity) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimensions.space10),
                      child: AppCard(
                        onTap: () => context.go('/trips'),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primarySurface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                PhosphorIconsRegular.clockCounterClockwise,
                                color: AppColors.primary,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.space12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activity.title,
                                    style: AppTypography.titleSmall.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    activity.subtitle,
                                    style: AppTypography.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              PhosphorIconsRegular.caretRight,
                              size: 16,
                              color: AppColors.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: AppDimensions.space32),
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